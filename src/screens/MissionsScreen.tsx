import React from 'react';
import { View, Text, ScrollView, StyleSheet } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Colors, Fonts, Radius } from '../constants/theme';
import { useGame } from '../hooks/useGameContext';
import { getMissionProgress } from '../lib/gameState';

export default function MissionsScreen() {
  const { state } = useGame();
  const missions = getMissionProgress(state);
  const done = missions.filter(m => m.completed).length;

  return (
    <SafeAreaView style={styles.safe} edges={['top']}>
      <ScrollView contentContainerStyle={styles.content} showsVerticalScrollIndicator={false}>
        <Text style={styles.title}>Daily Missions</Text>
        <Text style={styles.sub}>{done}/{missions.length} completed · {state.points} Payne Points</Text>

        {/* Streak card */}
        <View style={styles.streakCard}>
          <View style={{ flexDirection: 'row', alignItems: 'center', gap: 12 }}>
            <Text style={{ fontSize: 28 }}>🔥</Text>
            <View style={{ flex: 1 }}>
              <Text style={styles.streakVal}>{state.streak}-day streak</Text>
              <Text style={styles.streakHint}>Come back tomorrow to keep it going</Text>
            </View>
          </View>
          <View style={styles.track}><View style={[styles.fill, { width: `${Math.min(state.streak / 30 * 100, 100)}%` }]} /></View>
        </View>

        {/* Mission cards */}
        {missions.map(({ mission, completed, progress }) => (
          <View key={mission.id} style={[styles.missionCard, completed && styles.missionDone]}>
            <View style={{ flexDirection: 'row', alignItems: 'center', gap: 12 }}>
              <Text style={{ fontSize: 28 }}>{mission.emoji}</Text>
              <View style={{ flex: 1 }}>
                <Text style={[styles.missionTitle, completed && { color: Colors.accent }]}>{mission.title}</Text>
                <Text style={styles.missionDesc}>{mission.description}</Text>
              </View>
              <View style={styles.ptsBadge}><Text style={styles.ptsText}>+{mission.points}</Text></View>
            </View>
            <View style={styles.track}>
              <View style={[styles.fill, { width: `${progress * 100}%`, backgroundColor: completed ? Colors.accent : Colors.textMuted }]} />
            </View>
            {completed && <Text style={styles.completedTag}>✅ Completed</Text>}
          </View>
        ))}

        <View style={{ height: 32 }} />
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1, backgroundColor: Colors.bg },
  content: { padding: 20, gap: 12 },
  title: { fontFamily: Fonts.display, fontSize: 28, color: Colors.text },
  sub: { fontFamily: Fonts.body, fontSize: 13, color: Colors.textMuted, marginBottom: 4 },
  streakCard: { backgroundColor: Colors.accentDim, borderWidth: 1, borderColor: Colors.borderActive, borderRadius: Radius.lg, padding: 16, gap: 10 },
  streakVal: { fontFamily: Fonts.bodyBold, fontSize: 16, color: Colors.text },
  streakHint: { fontFamily: Fonts.body, fontSize: 12, color: Colors.textSecondary },
  track: { height: 3, backgroundColor: Colors.white08, borderRadius: 99, overflow: 'hidden' },
  fill: { height: '100%', backgroundColor: Colors.accent, borderRadius: 99 },
  missionCard: { backgroundColor: Colors.bgCard, borderWidth: 1, borderColor: Colors.border, borderRadius: Radius.lg, padding: 16, gap: 10 },
  missionDone: { borderColor: Colors.borderActive, backgroundColor: 'rgba(0,208,132,0.05)' },
  missionTitle: { fontFamily: Fonts.bodyBold, fontSize: 15, color: Colors.text },
  missionDesc: { fontFamily: Fonts.body, fontSize: 12, color: Colors.textMuted },
  ptsBadge: { backgroundColor: Colors.goldDim, paddingHorizontal: 10, paddingVertical: 4, borderRadius: Radius.pill },
  ptsText: { fontFamily: Fonts.bodyBold, fontSize: 12, color: Colors.gold },
  completedTag: { fontFamily: Fonts.bodySemiBold, fontSize: 11, color: Colors.accent, letterSpacing: 0.5 },
});
