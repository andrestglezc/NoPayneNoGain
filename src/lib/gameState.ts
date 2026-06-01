import { BADGES, Badge, DAILY_MISSIONS } from '../constants/gameData';

export interface GameState {
  totalTaps: number;
  sessionTaps: number;
  points: number;
  streak: number;
  lastActiveDate: string;
  unlockedBadges: string[];
  completedMissions: string[];
  sharesCount: number;
  chantsViewed: number;
  chantGenerated: boolean;
  installDate: string;
  dailyMissionDate: string;
}

function getToday(): string {
  return new Date().toISOString().split('T')[0];
}

const defaultState = (): GameState => ({
  totalTaps: 0,
  sessionTaps: 0,
  points: 0,
  streak: 1,
  lastActiveDate: getToday(),
  unlockedBadges: [],
  completedMissions: [],
  sharesCount: 0,
  chantsViewed: 0,
  chantGenerated: false,
  installDate: getToday(),
  dailyMissionDate: getToday(),
});

export async function loadState(): Promise<GameState> {
  return defaultState();
}

export async function saveState(_state: GameState): Promise<void> {}

export function checkBadgeUnlocks(state: GameState): Badge[] {
  return BADGES.filter(badge => {
    if (state.unlockedBadges.includes(badge.id)) return false;
    switch (badge.condition) {
      case 'install': return true;
      case 'tap_1': return state.totalTaps >= 1;
      case 'tap_100': return state.sessionTaps >= 100;
      case 'tap_1000': return state.totalTaps >= 1000;
      case 'tap_10000': return state.totalTaps >= 10000;
      case 'share_5': return state.sharesCount >= 5;
      case 'streak_3': return state.streak >= 3;
      case 'streak_7': return state.streak >= 7;
      case 'streak_14': return state.streak >= 14;
      case 'streak_30': return state.streak >= 30;
      case 'chant_generated': return state.chantGenerated;
      case 'missions_all': return state.completedMissions.length >= DAILY_MISSIONS.length;
      default: return false;
    }
  });
}

export function getMissionProgress(state: GameState) {
  return DAILY_MISSIONS.map(mission => {
    const completed = state.completedMissions.includes(mission.id);
    let progress = 0;
    if (!completed) {
      switch (mission.type) {
        case 'tap': progress = Math.min(state.sessionTaps / (mission.target || 1), 1); break;
        case 'share': progress = Math.min(state.sharesCount / 1, 1); break;
        case 'chant': progress = Math.min(state.chantsViewed / (mission.target || 1), 1); break;
        case 'streak': progress = Math.min(state.streak / (mission.target || 1), 1); break;
      }
    }
    return { mission, completed: completed || progress >= 1, progress };
  });
}
