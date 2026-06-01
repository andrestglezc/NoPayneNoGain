import React from 'react';
import { View, Text, Pressable, StyleSheet, Modal } from 'react-native';
import { Colors, Fonts, Radius } from '../constants/theme';
import { Badge, RARITY_COLORS } from '../constants/gameData';

export default function BadgeModal({ badge, onDismiss }: { badge: Badge; onDismiss: () => void }) {
  const color = RARITY_COLORS[badge.rarity];
  return (
    <Modal transparent animationType="fade" visible>
      <View style={styles.overlay}>
        <View style={[styles.card, { borderColor: color }]}>
          <Text style={styles.label}>🎉 BADGE UNLOCKED</Text>
          <Text style={styles.emoji}>{badge.emoji}</Text>
          <Text style={[styles.name, { color }]}>{badge.name}</Text>
          <Text style={styles.desc}>{badge.description}</Text>
          <Text style={[styles.rarity, { color }]}>{badge.rarity.toUpperCase()}</Text>
          <Pressable style={[styles.btn, { backgroundColor: color }]} onPress={onDismiss}>
            <Text style={styles.btnText}>Nice! 🎉</Text>
          </Pressable>
        </View>
      </View>
    </Modal>
  );
}

const styles = StyleSheet.create({
  overlay: { flex: 1, backgroundColor: 'rgba(0,0,0,0.85)', justifyContent: 'center', alignItems: 'center', padding: 32 },
  card: { backgroundColor: Colors.bgElevated, borderRadius: Radius.xl, borderWidth: 2, padding: 32, alignItems: 'center', width: '100%' },
  label: { fontFamily: Fonts.bodySemiBold, fontSize: 11, color: Colors.textMuted, letterSpacing: 2, marginBottom: 16 },
  emoji: { fontSize: 64, marginBottom: 12 },
  name: { fontFamily: Fonts.display, fontSize: 24, marginBottom: 6, textAlign: 'center' },
  desc: { fontFamily: Fonts.body, fontSize: 14, color: Colors.textSecondary, textAlign: 'center', marginBottom: 8 },
  rarity: { fontFamily: Fonts.bodySemiBold, fontSize: 11, letterSpacing: 2, marginBottom: 24 },
  btn: { paddingHorizontal: 32, paddingVertical: 13, borderRadius: Radius.pill },
  btnText: { fontFamily: Fonts.bodyBold, fontSize: 16, color: Colors.textInverse },
});
