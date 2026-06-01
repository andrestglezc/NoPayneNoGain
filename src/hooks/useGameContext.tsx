import React, { createContext, useContext, useEffect, useState, useCallback, useRef } from 'react';
import { GameState, loadState, saveState, checkBadgeUnlocks, getMissionProgress } from '../lib/gameState';
import { Badge } from '../constants/gameData';

interface GameContextType {
  state: GameState;
  addTap: () => void;
  addShare: () => void;
  addChantView: () => void;
  setChantGenerated: () => void;
  newBadges: Badge[];
  dismissBadge: () => void;
}

const GameContext = createContext<GameContextType | null>(null);

export function GameProvider({ children }: { children: React.ReactNode }) {
  const [state, setState] = useState<GameState | null>(null);
  const [newBadges, setNewBadges] = useState<Badge[]>([]);
  const timer = useRef<ReturnType<typeof setTimeout> | null>(null);

  useEffect(() => { loadState().then(setState); }, []);

  const update = useCallback((fn: (s: GameState) => GameState) => {
    setState(prev => {
      if (!prev) return prev;
      const next = fn(prev);
      // Check badge unlocks
      const unlocked = checkBadgeUnlocks(next);
      if (unlocked.length > 0) {
        next.unlockedBadges = [...next.unlockedBadges, ...unlocked.map(b => b.id)];
        setNewBadges(p => [...p, ...unlocked]);
      }
      // Auto-complete missions
      getMissionProgress(next).forEach(({ mission, completed }) => {
        if (completed && !next.completedMissions.includes(mission.id)) {
          next.completedMissions = [...next.completedMissions, mission.id];
          next.points += mission.points;
        }
      });
      // Debounced save
      if (timer.current) clearTimeout(timer.current);
      timer.current = setTimeout(() => saveState(next), 400);
      return { ...next };
    });
  }, []);

  const addTap = useCallback(() => update(s => ({ ...s, totalTaps: s.totalTaps + 1, sessionTaps: s.sessionTaps + 1 })), [update]);
  const addShare = useCallback(() => update(s => ({ ...s, sharesCount: s.sharesCount + 1 })), [update]);
  const addChantView = useCallback(() => update(s => ({ ...s, chantsViewed: s.chantsViewed + 1 })), [update]);
  const setChantGenerated = useCallback(() => update(s => ({ ...s, chantGenerated: true })), [update]);
  const dismissBadge = useCallback(() => setNewBadges(p => p.slice(1)), []);

  if (!state) return null;

  return (
    <GameContext.Provider value={{ state, addTap, addShare, addChantView, setChantGenerated, newBadges, dismissBadge }}>
      {children}
    </GameContext.Provider>
  );
}

export function useGame() {
  const ctx = useContext(GameContext);
  if (!ctx) throw new Error('useGame must be inside GameProvider');
  return ctx;
}
