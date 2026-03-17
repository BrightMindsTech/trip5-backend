import React, { useState, useEffect, useCallback, Component } from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { StatusBar } from 'expo-status-bar';
import { SafeAreaProvider, SafeAreaView } from 'react-native-safe-area-context';
import i18n, { initI18n } from './src/i18n';

class ErrorBoundary extends Component {
  state = { hasError: false, error: null };
  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }
  render() {
    if (this.state.hasError) {
      return (
        <View style={{ flex: 1, justifyContent: 'center', padding: 24, backgroundColor: '#fff' }}>
          <Text style={{ fontSize: 18, marginBottom: 12 }}>Something went wrong</Text>
          <Text style={{ color: '#666', fontSize: 14 }}>{String(this.state.error)}</Text>
        </View>
      );
    }
    return this.props.children;
  }
}
import { OrderProvider, useOrder } from './src/context/OrderContext';
import StepProgress from './src/components/StepProgress';
import LanguageToggle from './src/components/LanguageToggle';
import RouteScreen from './src/screens/RouteScreen';
import DateScreen from './src/screens/DateScreen';
import ServiceScreen from './src/screens/ServiceScreen';
import DetailsScreen from './src/screens/DetailsScreen';
import ConfirmationScreen from './src/screens/ConfirmationScreen';

function MainFlow() {
  const {
    order,
    updateOrder,
    currentStep,
    goNext,
    goBack,
    canProceedFromRoute,
    canProceedFromService,
    canProceedFromDetails,
    orderDate,
    isSubmitting,
    submitError,
    orderSent,
    submit,
    resetOrder,
    isValidPhone,
  } = useOrder();

  const [locale, setLocale] = useState(i18n.locale);

  useEffect(() => {
    initI18n()
      .then((lang) => setLocale(lang))
      .catch(() => setLocale('ar'));
  }, []);

  const refreshLocale = useCallback(() => {
    setLocale(i18n.locale);
  }, []);

  const renderStep = () => {
    switch (currentStep) {
      case 1:
        return (
          <RouteScreen
            order={order}
            updateOrder={updateOrder}
            goNext={goNext}
            canProceed={canProceedFromRoute}
          />
        );
      case 2:
        return (
          <DateScreen order={order} updateOrder={updateOrder} goNext={goNext} />
        );
      case 3:
        return (
          <ServiceScreen
            order={order}
            updateOrder={updateOrder}
            goNext={goNext}
            canProceed={canProceedFromService}
          />
        );
      case 4:
        return (
          <DetailsScreen
            order={order}
            updateOrder={updateOrder}
            goNext={goNext}
            canProceed={canProceedFromDetails}
            isValidPhone={isValidPhone}
          />
        );
      case 5:
        return (
          <ConfirmationScreen
            order={order}
            orderDate={orderDate}
            goBack={goBack}
            submit={submit}
            isSubmitting={isSubmitting}
            submitError={submitError}
            orderSent={orderSent}
            resetOrder={resetOrder}
          />
        );
      default:
        return null;
    }
  };

  return (
    <View style={styles.safe}>
      <SafeAreaView style={styles.safeInner} edges={['top']}>
      <StatusBar style="auto" />
      <View style={styles.header}>
        <View style={styles.headerLeft}>
          {currentStep > 1 && !orderSent && (
            <TouchableOpacity onPress={goBack} style={styles.backBtn}>
              <Text style={styles.backText}>{i18n.t('back')}</Text>
            </TouchableOpacity>
          )}
        </View>
        <Text style={styles.title}>Trip5</Text>
        <View style={styles.headerRight}>
          <LanguageToggle onToggle={refreshLocale} />
        </View>
      </View>
      {!orderSent && <StepProgress current={currentStep} total={5} />}
      <View style={styles.content}>{renderStep()}</View>
    </SafeAreaView>
    </View>
  );
}

export default function App() {
  return (
    <ErrorBoundary>
      <SafeAreaProvider>
        <OrderProvider>
          <MainFlow />
        </OrderProvider>
      </SafeAreaProvider>
    </ErrorBoundary>
  );
}

const styles = StyleSheet.create({
  safe: { flex: 1, backgroundColor: '#fff', minHeight: 200 },
  safeInner: { flex: 1 },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderBottomWidth: 1,
    borderBottomColor: '#eee',
  },
  headerLeft: { width: 80, alignItems: 'flex-start' },
  headerRight: { width: 80, alignItems: 'flex-end' },
  title: { fontSize: 20, fontWeight: '700' },
  backBtn: { padding: 8 },
  backText: { color: '#4CAF50', fontWeight: '600' },
  content: { flex: 1 },
});
