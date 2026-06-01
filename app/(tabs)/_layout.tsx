import { Tabs } from 'expo-router';
import { Text, View, StyleSheet } from 'react-native';
import { Colors, Fonts } from '../../src/constants/theme';
import { useGame } from '../../src/hooks/useGameContext';
import BadgeModal from '../../src/components/BadgeModal';

function TabIcon({ emoji, label, focused }: { emoji: string; label: string; focused: boolean }) {
  return (
    <View style={styles.tab}>
      <Text style={{ fontSize: 22, opacity: focused ? 1 : 0.45 }}>{emoji}</Text>
      <Text style={[styles.tabLabel, focused && { color: Colors.accent }]}>{label}</Text>
    </View>
  );
}

export default function TabsLayout() {
  const { newBadges, dismissBadge } = useGame();
  return (
    <>
      <Tabs screenOptions={{ headerShown: false, tabBarStyle: styles.bar, tabBarShowLabel: false }}>
        <Tabs.Screen name="index" options={{ tabBarIcon: ({ focused }) => <TabIcon emoji="🇳🇿" label="Hype" focused={focused} /> }} />
        <Tabs.Screen name="missions" options={{ tabBarIcon: ({ focused }) => <TabIcon emoji="⚽" label="Missions" focused={focused} /> }} />
        <Tabs.Screen name="chants" options={{ tabBarIcon: ({ focused }) => <TabIcon emoji="🎵" label="Chants" focused={focused} /> }} />
        <Tabs.Screen name="profile" options={{ tabBarIcon: ({ focused }) => <TabIcon emoji="🏆" label="Profile" focused={focused} /> }} />
      </Tabs>
      {newBadges.length > 0 && <BadgeModal badge={newBadges[0]} onDismiss={dismissBadge} />}
    </>
  );
}

const styles = StyleSheet.create({
  bar: { backgroundColor: Colors.bgElevated, borderTopColor: Colors.border, borderTopWidth: 1, height: 84, paddingBottom: 20, paddingTop: 8 },
  tab: { alignItems: 'center', gap: 2 },
  tabLabel: { fontFamily: Fonts.bodyMedium, fontSize: 10, color: Colors.textMuted, letterSpacing: 0.5 },
});
