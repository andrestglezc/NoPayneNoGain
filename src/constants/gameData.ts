export const CHANTS = [
  "Been loving you since the day I saw you (today) 🔥",
  "My mother gave me life, and Tim gave me the will to live it.",
  "No Payne, No Gain. This is law.",
  "I don't know what a Wellington Phoenix is but I'd die for it.",
  "Tim Payne is the People's World Cup.",
  "He had 4,700 followers. Now he has an army.",
  "El Scarso found him. The world kept him.",
  "Group G is Tim's group now. Everyone else is visiting.",
  "This man trained his whole life for this moment. We're the moment.",
  "I searched every squad. Tim was waiting for me.",
  "He's not just a defender. He defends our hearts.",
  "4,700 to 2.5 million. That's not followers, that's a movement.",
  "He is already the player of the tournament.",
  "One influencer. One defender. Seven billion potential fans.",
];

export const CHANT_TEMPLATES = [
  "No Payne, no gain!\n{name} believes in Tim!\nFrom {country} to Wellington,\nTim Payne is our champion! 🇳🇿⚽",
  "Ohhh Tim Payne!\n{name} is with you!\nFrom 4,700 to millions,\nThe people's player! 🔥",
  "Dale Tim! Dale Tim!\n{name} supports you!\nWellington to the world,\n{country} loves you! 🌍⚽",
  "🎵 He came from New Zealand,\nWith just 4,700 fans,\nNow {name} from {country}\nIs part of Tim's clan! 🇳🇿",
];

export interface Badge {
  id: string;
  name: string;
  description: string;
  emoji: string;
  rarity: 'common' | 'rare' | 'epic' | 'legendary';
  condition: string;
}

export const BADGES: Badge[] = [
  { id: 'first_tap', name: 'First Touch', description: 'Your first tap for Tim', emoji: '👆', rarity: 'common', condition: 'tap_1' },
  { id: 'century', name: 'Century', description: '100 taps in one session', emoji: '💯', rarity: 'common', condition: 'tap_100' },
  { id: 'thousand', name: 'Ultra', description: '1,000 total taps', emoji: '⚡', rarity: 'rare', condition: 'tap_1000' },
  { id: 'ten_k', name: "Tim's Army", description: '10,000 total taps', emoji: '🪖', rarity: 'epic', condition: 'tap_10000' },
  { id: 'sharer', name: 'El Scarso Jr', description: 'Shared 5 chant cards', emoji: '📢', rarity: 'rare', condition: 'share_5' },
  { id: 'streak3', name: 'On Fire', description: '3-day streak', emoji: '🔥', rarity: 'common', condition: 'streak_3' },
  { id: 'streak7', name: 'No Days Off', description: '7-day streak', emoji: '💎', rarity: 'rare', condition: 'streak_7' },
  { id: 'streak14', name: 'True Believer', description: '14-day streak', emoji: '🏆', rarity: 'epic', condition: 'streak_14' },
  { id: 'streak30', name: 'Legendary Fan', description: '30-day streak', emoji: '👑', rarity: 'legendary', condition: 'streak_30' },
  { id: 'polyglot', name: 'Polyglot', description: 'Generated a custom chant', emoji: '🇦🇷', rarity: 'common', condition: 'chant_generated' },
  { id: 'day1', name: 'Day 1 Fan', description: 'Here from the start', emoji: '🏟️', rarity: 'rare', condition: 'install' },
  { id: 'fan_army', name: 'Fan Army', description: 'Completed all daily missions', emoji: '✅', rarity: 'epic', condition: 'missions_all' },
];

export const RARITY_COLORS = {
  common: '#A0AEC0',
  rare: '#00D084',
  epic: '#9F7AEA',
  legendary: '#FFD700',
} as const;

export const TIM_FACTS = [
  { emoji: '🏆', label: 'Tournament', value: 'World Cup 2026' },
  { emoji: '🏟️', label: 'Club', value: 'Wellington Phoenix' },
  { emoji: '🌏', label: 'Group', value: 'G' },
  { emoji: '⚡', label: 'Position', value: 'Right Back' },
  { emoji: '🇳🇿', label: 'Nation', value: 'New Zealand' },
  { emoji: '🚀', label: 'Peak followers', value: '2.5M+' },
];

export interface Mission {
  id: string;
  title: string;
  description: string;
  emoji: string;
  points: number;
  type: string;
  target?: number;
}

export const DAILY_MISSIONS: Mission[] = [
  { id: 'tap50', title: 'Warm Up', description: 'Tap 50 times for Tim', emoji: '👆', points: 10, type: 'tap', target: 50 },
  { id: 'tap200', title: 'Full 90 Minutes', description: 'Tap 200 times today', emoji: '⚽', points: 30, type: 'tap', target: 200 },
  { id: 'share1', title: 'Spread the Word', description: 'Share a chant card', emoji: '📤', points: 25, type: 'share' },
  { id: 'chant3', title: 'Choir Practice', description: 'Browse 3 fan chants', emoji: '🎵', points: 15, type: 'chant', target: 3 },
  { id: 'streak3', title: 'Consistent Fan', description: '3-day streak', emoji: '🔥', points: 50, type: 'streak', target: 3 },
];
