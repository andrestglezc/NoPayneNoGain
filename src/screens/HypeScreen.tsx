import React, { useState, useCallback, useRef } from 'react';
import { View, Text, Pressable, ScrollView, StyleSheet, Dimensions, Share } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import * as Haptics from 'expo-haptics';
import { Colors, Fonts, Radius } from '../constants/theme';
import { CHANTS, TIM_FACTS } from '../constants/gameData';
import { useGame } from '../hooks/useGameContext';

const { width } = Dimensions.get('window');

function fmt(n: number) {
  if (n >= 1_000_000) return (n / 1_000_000).toFixed(1) + 'M';
  if (n >= 1_000) return (n / 1_000).toFixed(1) + 'K';
  return n.toString();
}

export default function HypeScreen() {
  const { state, addTap, addShare } = useGame();
  const [chantIdx, setChantIdx] = useState(0);
  const [pressed, setPressed] = useState(false);

  const handleTap = useCallback(() => {
    addTap();
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    setPressed(true);
    setTimeout(() => setPressed(false), 100);
    setChantIdx(prev => (prev + 1) % CHANTS.length);
  }, [addTap]);

  const handleShare = useCallback(async () => {
    await Share.share({ message: `${CHANTS[chantIdx]}\n\n🇳🇿 No Payne, No Gain — Download the app!` });
    addShare();
  }, [chantIdx, addShare]);

  const globalCount = 4715 + state.totalTaps * 347;

  return (
    <SafeAreaView style={styles.safe} edges={['top']}>
      <ScrollView contentContainerStyle={styles.content} showsVerticalScrollIndicator={false}>

        {/* Header */}
        <View style={styles.pill}><Text style={styles.pillText}>⚽ FIFA WORLD CUP 2026</Text></View>
        <Text style={styles.title}>TIM{'\n'}PAYNE</Text>
        <Text style={styles.subtitle}>The People's Player · <Text style={{ color: Colors.accent }}>All Whites</Text> · Group G</Text>

        {/* Counter */}
        <View style={styles.card}>
          <Text style={styles.cardLabel}>TIM'S ARMY — GLOBAL SUPPORT</Text>
          <View style={{ flexDirection: 'row', alignItems: 'center', gap: 12 }}>
            <Text style={styles.counterOld}>4.7K</Text>
            <Text style={{ color: Colors.white20, fontSize: 16 }}>→</Text>
            <Text style={styles.counterBig}>{fmt(globalCount)}</Text>
          </View>
          <View style={styles.track}><View style={[styles.fill, { width: `${Math.min(globalCount / 2_500_000 * 100, 100)}%` }]} /></View>
          <Text style={styles.cardHint}>You've tapped {state.totalTaps.toLocaleString()} times</Text>
        </View>

        {/* Tap button */}
        <Pressable onPress={handleTap} style={[styles.tapBtn, pressed && { transform: [{ scale: 0.95 }], shadowOpacity: 0 }]}>
          <Text style={{ fontSize: 44 }}>🇳🇿</Text>
          <Text style={styles.tapLabel}>TAP FOR TIM</Text>
          <Text style={styles.tapSub}>+1 to the army</Text>
        </Pressable>

        {/* Stats row */}
        <View style={styles.statsRow}>
          {[
            { v: state.sessionTaps, l: 'Today' },
            { v: `${state.streak}🔥`, l: 'Streak' },
            { v: state.points, l: 'Points' },
          ].map(s => (
            <View key={s.l} style={styles.statCell}>
              <Text style={styles.statVal}>{s.v}</Text>
              <Text style={styles.statLbl}>{s.l}</Text>
            </View>
          ))}
        </View>

        {/* Chant card */}
        <View style={styles.card}>
          <Text style={styles.bigQuote}>"</Text>
          <Text style={styles.chantText}>{CHANTS[chantIdx]}</Text>
          <View style={{ flexDirection: 'row', justifyContent: 'space-between', marginTop: 10, alignItems: 'center' }}>
            <Text style={styles.cardHint}>— The internet, 2026</Text>
            <Pressable onPress={handleShare} style={styles.shareBtn}><Text style={styles.shareBtnText}>📤 Share</Text></Pressable>
          </View>
        </View>

        {/* Tim facts */}
        <Text style={styles.sectionTitle}>The Legend</Text>
        <View style={styles.grid}>
          {TIM_FACTS.map(f => (
            <View key={f.label} style={styles.factCell}>
              <Text style={{ fontSize: 20 }}>{f.emoji}</Text>
              <Text style={styles.factVal}>{f.value}</Text>
              <Text style={styles.factLbl}>{f.label}</Text>
            </View>
          ))}
        </View>

        {/* Story */}
        <View style={styles.card}>
          <Text style={styles.sectionTitle}>How it started</Text>
          <Text style={styles.storyText}>
            Argentine influencer El Scarso searched every World Cup squad for the least-known player. He found Tim Payne — a right back from Wellington with 4,715 Instagram followers. He asked the internet to follow him. Within 48 hours, Tim hit 2.5 million. Brands piled in. A song was written. T-shirts were printed in Buenos Aires.
          </Text>
          <Text style={{ fontFamily: Fonts.displayItalic, fontSize: 14, color: Colors.accent, marginTop: 8 }}>No Payne, No Gain. 🏆</Text>
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
  pill: { alignSelf: 'flex-start', backgroundColor: Colors.white08, borderWidth: 1, borderColor: Colors.white12, paddingHorizontal: 12, paddingVertical: 4, borderRadius: Radius.pill },
  pillText: { fontFamily: Fonts.bodySemiBold, fontSize: 10, color: Colors.textMuted, letterSpacing: 1.5 },
  title: { fontFamily: Fonts.displayItalic, fontSize: 64, lineHeight: 60, color: Colors.text, letterSpacing: -2 },
  subtitle: { fontFamily: Fonts.body, fontSize: 13, color: Colors.textMuted },
  card: { backgroundColor: Colors.bgCard, borderWidth: 1, borderColor: Colors.border, borderRadius: Radius.lg, padding: 16, gap: 8 },
  cardLabel: { fontFamily: Fonts.bodySemiBold, fontSize: 10, color: Colors.textMuted, letterSpacing: 2 },
  cardHint: { fontFamily: Fonts.body, fontSize: 11, color: Colors.textMuted },
  counterOld: { fontFamily: Fonts.displayItalic, fontSize: 18, color: Colors.white20, textDecorationLine: 'line-through' },
  counterBig: { fontFamily: Fonts.displayItalic, fontSize: 44, color: Colors.accent, letterSpacing: -1 },
  track: { height: 3, backgroundColor: Colors.white08, borderRadius: 99, overflow: 'hidden' },
  fill: { height: '100%', backgroundColor: Colors.accent, borderRadius: 99 },
  tapBtn: { backgroundColor: '#004d30', borderWidth: 1, borderColor: Colors.borderActive, borderRadius: Radius.xl, paddingVertical: 26, alignItems: 'center', gap: 6, shadowColor: Colors.accent, shadowOffset: { width: 0, height: 0 }, shadowOpacity: 0.3, shadowRadius: 20, elevation: 8 },
  tapLabel: { fontFamily: Fonts.bodyBold, fontSize: 15, color: Colors.accent, letterSpacing: 2 },
  tapSub: { fontFamily: Fonts.body, fontSize: 12, color: Colors.textMuted },
  statsRow: { flexDirection: 'row', gap: 8 },
  statCell: { flex: 1, backgroundColor: Colors.bgCard, borderWidth: 1, borderColor: Colors.border, borderRadius: Radius.md, padding: 12, alignItems: 'center', gap: 2 },
  statVal: { fontFamily: Fonts.bodyBold, fontSize: 18, color: Colors.text },
  statLbl: { fontFamily: Fonts.body, fontSize: 10, color: Colors.textMuted, textTransform: 'uppercase', letterSpacing: 0.5 },
  bigQuote: { fontFamily: Fonts.displayItalic, fontSize: 36, color: Colors.accentDim, lineHeight: 36, position: 'absolute', top: 8, left: 14 },
  chantText: { fontFamily: Fonts.displayItalic, fontSize: 15, color: Colors.textSecondary, lineHeight: 22, paddingTop: 10, paddingLeft: 4 },
  shareBtn: { backgroundColor: Colors.accentDim, borderRadius: Radius.pill, paddingHorizontal: 14, paddingVertical: 6 },
  shareBtnText: { fontFamily: Fonts.bodySemiBold, fontSize: 12, color: Colors.accent },
  sectionTitle: { fontFamily: Fonts.display, fontSize: 20, color: Colors.text },
  grid: { flexDirection: 'row', flexWrap: 'wrap', gap: 8 },
  factCell: { width: CELL, backgroundColor: Colors.bgCard, borderWidth: 1, borderColor: Colors.border, borderRadius: Radius.md, padding: 12, alignItems: 'center', gap: 4 },
  factVal: { fontFamily: Fonts.bodyBold, fontSize: 11, color: Colors.text, textAlign: 'center' },
  factLbl: { fontFamily: Fonts.body, fontSize: 9, color: Colors.textMuted, letterSpacing: 0.8, textTransform: 'uppercase', textAlign: 'center' },
  storyText: { fontFamily: Fonts.body, fontSize: 13, color: Colors.textSecondary, lineHeight: 20 },
});
