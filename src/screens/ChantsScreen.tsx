import React, { useState } from 'react';
import { View, Text, TextInput, Pressable, ScrollView, StyleSheet, Share, Alert } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import * as Haptics from 'expo-haptics';
import { Colors, Fonts, Radius } from '../constants/theme';
import { CHANTS, CHANT_TEMPLATES } from '../constants/gameData';
import { useGame } from '../hooks/useGameContext';

export default function ChantsScreen() {
  const { addChantView, addShare, setChantGenerated } = useGame();
  const [name, setName] = useState('');
  const [country, setCountry] = useState('');
  const [generated, setGenerated] = useState('');
  const [idx, setIdx] = useState(0);

  const generate = () => {
    if (!name.trim()) { Alert.alert('Enter your name', 'We need it for the chant!'); return; }
    const tmpl = CHANT_TEMPLATES[Math.floor(Math.random() * CHANT_TEMPLATES.length)];
    setGenerated(tmpl.replace(/\{name\}/g, name.trim()).replace(/\{country\}/g, country.trim() || 'Planet Earth'));
    setChantGenerated();
    Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success);
  };

  const shareText = async (text: string) => {
    await Share.share({ message: `${text}\n\n🇳🇿 No Payne, No Gain` });
    addShare();
  };

  const next = () => { setIdx(p => (p + 1) % CHANTS.length); addChantView(); Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light); };

  return (
    <SafeAreaView style={styles.safe} edges={['top']}>
      <ScrollView contentContainerStyle={styles.content} showsVerticalScrollIndicator={false}>
        <Text style={styles.title}>Chants</Text>
        <Text style={styles.sub}>Generate yours or browse fan favourites</Text>

        {/* Generator */}
        <View style={styles.card}>
          <Text style={styles.cardTitle}>🎵 Create Your Chant</Text>
          <TextInput style={styles.input} placeholder="Your name" placeholderTextColor={Colors.textMuted} value={name} onChangeText={setName} maxLength={30} />
          <TextInput style={styles.input} placeholder="Your country (optional)" placeholderTextColor={Colors.textMuted} value={country} onChangeText={setCountry} maxLength={30} />
          <Pressable style={styles.genBtn} onPress={generate}><Text style={styles.genBtnText}>Generate Chant 🎶</Text></Pressable>
        </View>

        {/* Generated output */}
        {generated !== '' && (
          <View style={[styles.card, { borderColor: Colors.borderActive }]}>
            <Text style={styles.generatedText}>{generated}</Text>
            <Pressable style={styles.shareBtn} onPress={() => shareText(generated)}><Text style={styles.shareBtnText}>📤 Share This Chant</Text></Pressable>
          </View>
        )}

        {/* Fan chants */}
        <Text style={styles.sectionTitle}>Fan Chants</Text>
        <Pressable style={styles.card} onPress={next}>
          <Text style={styles.bigQuote}>"</Text>
          <Text style={styles.chantText}>{CHANTS[idx]}</Text>
          <View style={{ flexDirection: 'row', justifyContent: 'space-between', marginTop: 10 }}>
            <Text style={styles.chantSrc}>— The internet · tap to cycle</Text>
            <Text style={styles.chantSrc}>{idx + 1}/{CHANTS.length}</Text>
          </View>
        </Pressable>
        <Pressable style={styles.outlineBtn} onPress={() => shareText(CHANTS[idx])}><Text style={styles.outlineBtnText}>📤 Share This One</Text></Pressable>

        <View style={{ height: 32 }} />
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1, backgroundColor: Colors.bg },
  content: { padding: 20, gap: 14 },
  title: { fontFamily: Fonts.display, fontSize: 28, color: Colors.text },
  sub: { fontFamily: Fonts.body, fontSize: 13, color: Colors.textMuted },
  card: { backgroundColor: Colors.bgCard, borderWidth: 1, borderColor: Colors.border, borderRadius: Radius.lg, padding: 16, gap: 10 },
  cardTitle: { fontFamily: Fonts.bodyBold, fontSize: 16, color: Colors.text },
  input: { backgroundColor: Colors.white08, borderRadius: Radius.md, padding: 14, fontFamily: Fonts.body, fontSize: 15, color: Colors.text },
  genBtn: { backgroundColor: Colors.accent, borderRadius: Radius.pill, padding: 14, alignItems: 'center' },
  genBtnText: { fontFamily: Fonts.bodyBold, fontSize: 15, color: Colors.textInverse },
  generatedText: { fontFamily: Fonts.displayItalic, fontSize: 16, color: Colors.text, lineHeight: 24 },
  shareBtn: { backgroundColor: Colors.accent, borderRadius: Radius.pill, padding: 12, alignItems: 'center' },
  shareBtnText: { fontFamily: Fonts.bodyBold, fontSize: 14, color: Colors.textInverse },
  sectionTitle: { fontFamily: Fonts.display, fontSize: 20, color: Colors.text, marginTop: 8 },
  bigQuote: { fontFamily: Fonts.displayItalic, fontSize: 36, color: Colors.accentDim, lineHeight: 36, position: 'absolute', top: 8, left: 14 },
  chantText: { fontFamily: Fonts.displayItalic, fontSize: 15, color: Colors.textSecondary, lineHeight: 22, paddingTop: 10, paddingLeft: 4 },
  chantSrc: { fontFamily: Fonts.body, fontSize: 11, color: Colors.textMuted },
  outlineBtn: { backgroundColor: Colors.white08, borderRadius: Radius.pill, padding: 12, alignItems: 'center' },
  outlineBtnText: { fontFamily: Fonts.bodySemiBold, fontSize: 13, color: Colors.textSecondary },
});
