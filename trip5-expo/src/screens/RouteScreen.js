import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import i18n from '../i18n';

export default function RouteScreen({ order, updateOrder, goNext, canProceed }) {
  const RouteCard = ({ title, route, isSelected }) => (
    <TouchableOpacity
      style={[styles.card, isSelected && styles.cardSelected]}
      onPress={() => updateOrder({ route })}
      activeOpacity={0.8}
    >
      <Text style={[styles.cardTitle, isSelected && styles.cardTitleSelected]}>{title}</Text>
      {isSelected && <Text style={styles.check}>✓</Text>}
    </TouchableOpacity>
  );

  return (
    <View style={styles.container}>
      <Text style={styles.title}>{i18n.t('choose_route')}</Text>
      <RouteCard
        title={i18n.t('route_irbid_to_amman')}
        route="irbid_to_amman"
        isSelected={order.route === 'irbid_to_amman'}
      />
      <RouteCard
        title={i18n.t('route_amman_to_irbid')}
        route="amman_to_irbid"
        isSelected={order.route === 'amman_to_irbid'}
      />
      <TouchableOpacity
        style={[styles.button, !canProceed && styles.buttonDisabled]}
        onPress={goNext}
        disabled={!canProceed}
      >
        <Text style={styles.buttonText}>{i18n.t('next')}</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 24, paddingTop: 48 },
  title: { fontSize: 22, fontWeight: '600', marginBottom: 24, textAlign: 'center' },
  card: {
    backgroundColor: '#f0f0f0',
    padding: 20,
    borderRadius: 12,
    marginBottom: 16,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  cardSelected: { backgroundColor: '#4CAF50' },
  cardTitle: { fontSize: 18, fontWeight: '500' },
  cardTitleSelected: { color: '#fff' },
  check: { color: '#fff', fontSize: 20 },
  button: {
    backgroundColor: '#4CAF50',
    padding: 16,
    borderRadius: 12,
    marginTop: 'auto',
    alignItems: 'center',
  },
  buttonDisabled: { backgroundColor: '#ccc' },
  buttonText: { color: '#fff', fontSize: 18, fontWeight: '600' },
});
