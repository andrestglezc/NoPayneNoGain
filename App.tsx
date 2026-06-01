import React, { useEffect } from 'react';
import { NavigationContainer, DefaultTheme } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { Text, View, StyleSheet } from 'react-native';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { useFonts, PlayfairDisplay_700Bold, PlayfairDisplay_700Bold_Italic } from '@expo-google-fonts/playfair-display';
import { DMSans_400Regular, DMSans_500Medium, DMSans_600SemiBold, DMSans_700Bold } from '@expo-google-fonts/dm-sans';
import { StatusBar } from 'expo-status-bar';
import * as SplashScreen from 'expo-splash-screen';
import { GameProvider, useGame } from './src/hooks/useGameContext';
import { Colors, Fonts } from './src/constants/theme';
import HypeScreen from './src/screens/HypeScreen';
import MissionsScreen from './src/screens/MissionsScreen';
import ChantsScreen from './src/screens/ChantsScreen';
import ProfileScreen from './src/screens/ProfileScreen';
import BadgeModal from './src/components/BadgeModal';

SplashScreen.preventAutoHideAsync();
const Tab = createBottomTabNavigator();

const theme = {
  ...DefaultTheme,
  colors: { ...DefaultTheme.colors, background: Colors.bg },
};

function TabIcon({ emoji, label, focused }: { emoji: string; label: string; focused: boolean }) {
  return (
    <View style={styles.tab}>
      <Text style={{ fontSize: 22, opacity: focused ? 1 : 0.45 }}>{emoji}</Text>
      <Text style={[styles.tabLabel, focused && { color: Colors.accent }]}>{label}</Text>
    </View>
  );
}

function AppNavigator() {
  const { newBadges, dismissBadge } = useGame();
  return (
    <>
      <Tab.Navigator screenOptions={{ headerShown: false, tabBarStyle: styles.bar, tabBarShowLabel: false }}>
        <Tab.Screen name="Hype" component={HypeScreen} options={{ tabBarIcon: ({ focused }) => <TabIcon emoji="🇳🇿" label="Hype" focused={focused} /> }} />
        <Tab.Screen name="Missions" component={MissionsScreen} options={{ tabBarIcon: ({ focused }) => <TabIcon emoji="⚽" label="Missions" focused={focused} /> }} />
        <Tab.Screen name="Chants" component={ChantsScreen} options={{ tabBarIcon: ({ focused }) => <TabIcon emoji="🎵" label="Chants" focused={focused} /> }} />
        <Tab.Screen name="Profile" component={ProfileScreen} options={{ tabBarIcon: ({ focused }) => <TabIcon emoji="🏆" label="Profile" focused={focused} /> }} />
      </Tab.Navigator>
      {newBadges.length > 0 && <BadgeModal badge={newBadges[0]} onDismiss={dismissBadge} />}
    </>
  );
}

export default function App() {
  const [fontsLoaded] = useFonts({
    PlayfairDisplay_700Bold,
    PlayfairDisplay_700Bold_Italic,
    DMSans_400Regular,
    DMSans_500Medium,
    DMSans_600SemiBold,
    DMSans_700Bold,
  });

  useEffect(() => {
    if (fontsLoaded) SplashScreen.hideAsync();
  }, [fontsLoaded]);

  if (!fontsLoaded) return null;

  return (
    <SafeAreaProvider>
      <GameProvider>
        <NavigationContainer theme={theme}>
          <StatusBar style="light" />
          <AppNavigator />
        </NavigationContainer>
      </GameProvider>
    </SafeAreaProvider>
  );
}

const styles = StyleSheet.create({
  bar: { backgroundColor: Colors.bgElevated, borderTopColor: Colors.border, borderTopWidth: 1, height: 84, paddingBottom: 20, paddingTop: 8 },
  tab: { alignItems: 'center', gap: 2 },
  tabLabel: { fontFamily: Fonts.bodyMedium, fontSize: 10, color: Colors.textMuted, letterSpacing: 0.5 },
});
