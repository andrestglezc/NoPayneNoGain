import React from 'react';
import { View, Text, ScrollView, StyleSheet, Dimensions, Linking, Pressable } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Colors, Fonts, Radius } from '../constants/theme';
import { BADGES, RARITY_COLORS } from '../constants/gameData';
import { useGame } from '../hooks/useGameContext';

const { width } = Dimensions.get('window');
const BADGE_W = (width - 40 - 24) / 4;

export default function ProfileScreen() {
  const { state } = useGame();

  const stats = [
    { e: '👆', v: state.totalTaps.toLocaleString(), l: 'Total Taps' },
    { e: '⭐', v: state.points.toLocaleString(), l: 'Points' },
    { e: '🔥', v: `${state.streak}d`, l: 'Streak' },
    { e: '📤', v: state.sharesCount.toString(), l: 'Shares' },
    { e: '🏆', v: `${state.unlockedBadges.length}/${BADGES.length}`, l: 'Badges' },
    { e: '📅', v: state.installDate, l: 'Since' },
  ];

  return (
    <SafeAreaView style={styles.safe} edges={['top']}>
      <ScrollView contentContainerStyle={styles.content} showsVerticalScrollIndicator={false}>
        <Text style={styles.title}>Your Profile</Text>
        <Text style={styles.sub}>Tim Payne's Army · Fan since {state.installDate}</Text>

        {/* Stats */}
        <View style={styles.grid}>
          {stats.map(s => (
            <View key={s.l} style={styles.statCell}>
              <Text style={{ fontSize: 22 }}>{s.e}</Text>
              <Text style={styles.statVal}>{s.v}</Text>
              <Text style={styles.statLbl}>{s.l}</Text>
            </View>
          ))}
        </View>

        {/* Badges */}
        <Text style={styles.sectionTitle}>Badge Collection</Text>
        <Text style={styles.sub}>{state.unlockedBadges.length} of {BADGES.length} unlocked</Text>
        <View style={styles.badgeGrid}>
          {BADGES.map(badge => {
            const unlocked = state.unlockedBadges.includes(badge.id);
            const color = RARITY_COLORS[badge.rarity];
            return (
              <View key={badge.id} style={[styles.badgeCell, unlocked && { borderColor: color, backgroundColor: `${color}12` }]}>
                <Text style={{ fontSize: 26, opacity: unlocked ? 1 : 0.25 }}>{unlocked ? badge.emoji : '🔒'}</Text>
                <Text style={[styles.badgeName, { color: unlocked ? color : Colors.textMuted }]} numberOfLines={1}>{badge.name}</Text>
                <Text style={[styles.badgeRarity, { color: unlocked ? color : Colors.textMuted }]}>{badge.rarity.slice(0, 3).toUpperCase()}</Text>
              </View>
            );
          })}
        </View>

        {/* Rarity legend */}
        <View style={styles.legend}>
          {Object.entries(RARITY_COLORS).map(([name, color]) => (
            <View key={name} style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}>
              <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: color }} />
              <Text style={[styles.legendText, { color }]}>{name}</Text>
            </View>
          ))}
        </View>

        {/* Links */}
        <View style={styles.card}>
          <Text style={styles.cardTitle}>Follow Tim</Text>
          <Pressable onPress={() => Linking.openURL('https://instagram.com')}><Text style={styles.link}>📸 Instagram — @timpayne</Text></Pressable>
          <Pressable onPress={() => Linking.openURL('https://instagram.com')}><Text style={styles.link}>🇦🇷 El Scarso — @elscarso</Text></Pressable>
        </View>

        {/* About */}
        <View style={styles.card}>
          <Text style={styles.cardTitle}>About</Text>
          <Text style={styles.about}>Unofficial fan app. Not affiliated with FIFA, Wellington Phoenix, or Tim Payne. Made with love by fans, for fans.</Text>
          <Text style={styles.version}>v1.0.0 · No Payne, No Gain 🇳🇿</Text>
        </View>

        <View style={{ height: 32 }} />
      </ScrollView>
    </SafeAreaView>
  );
}

const CELL = (width - 40 - 16) / 3;

const styles = StyleSheet.create({
  safe: { flex: 1, backgroundColor: Colors.bg },
  content: { padding: 20, gap: 14 },
  title: { fontFamily: Fonts.display, fontSize: 28, color: Colors.text },
  sub: { fontFamily: Fonts.body, fontSize: 13, color: Colors.textMuted },
  grid: { flexDirection: 'row', flexWrap: 'wrap', gap: 8 },
  statCell: { width: CELL, backgroundColor: Colors.bgCard, borderWidth: 1, borderColor: Colors.border, borderRadius: Radius.md, padding: 14, alignItems: 'center', gap: 4 },
  statVal: { fontFamily: Fonts.bodyBold, fontSize: 16, color: Colors.text },
  statLbl: { fontFamily: Fonts.body, fontSize: 10, color: Colors.textMuted, letterSpacing: 0.5, textTransform: 'uppercase' },
  sectionTitle: { fontFamily: Fonts.display, fontSize: 20, color: Colors.text, marginTop: 8 },
  badgeGrid: { flexDirection: 'row', flexWrap: 'wrap', gap: 8 },
  badgeCell: { width: BADGE_W, backgroundColor: Colors.bgCard, borderWidth: 1, borderColor: Colors.border, borderRadius: Radius.md, padding: 10, alignItems: 'center', gap: 3 },
  badgeName: { fontFamily: Fonts.bodySemiBold, fontSize: 8, textAlign: 'center' },
  badgeRarity: { fontFamily: Fonts.bodySemiBold, fontSize: 7, letterSpacing: 1 },
  legend: { flexDirection: 'row', gap: 14, justifyContent: 'center' },
  legendText: { fontFamily: Fonts.body, fontSize: 10, textTransform: 'uppercase', letterSpacing: 0.5 },
  card: { backgroundColor: Colors.bgCard, borderWidth: 1, borderColor: Colors.border, borderRadius: Radius.lg, padding: 16, gap: 8 },
  cardTitle: { fontFamily: Fonts.bodyBold, fontSize: 15, color: Colors.text },
  link: { fontFamily: Fonts.bodyMedium, fontSize: 14, color: Colors.accent },
  about: { fontFamily: Fonts.body, fontSize: 13, color: Colors.textSecondary, lineHeight: 19 },
  version: { fontFamily: Fonts.body, fontSize: 11, color: Colors.textMuted },
});
