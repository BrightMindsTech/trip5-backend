import React from 'react';
import { TouchableOpacity, Text, StyleSheet } from 'react-native';
import i18n, { setLanguage } from '../i18n';

export default function LanguageToggle({ onToggle }) {
  const isArabic = i18n.locale === 'ar';
  const toggle = async () => {
    const next = isArabic ? 'en' : 'ar';
    await setLanguage(next);
    onToggle?.();
  };
  return (
    <TouchableOpacity onPress={toggle} style={styles.btn}>
      <Text style={styles.text}>{isArabic ? 'English' : 'العربية'}</Text>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  btn: { paddingHorizontal: 12, paddingVertical: 6 },
  text: { color: '#4CAF50', fontWeight: '600', fontSize: 14 },
});
