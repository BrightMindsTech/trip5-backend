import React, { createContext, useContext, useState, useCallback } from 'react';
import { submitOrder } from '../api';

const OrderContext = createContext();

export const useOrder = () => useContext(OrderContext);

const initialOrder = {
  route: null,
  isToday: true,
  scheduledDate: new Date(),
  service: null,
  fullName: '',
  phoneNumber: '',
  pickup: null,
  destination: null,
};

export function OrderProvider({ children }) {
  const [order, setOrder] = useState(initialOrder);
  const [currentStep, setCurrentStep] = useState(1);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitError, setSubmitError] = useState(null);
  const [orderSent, setOrderSent] = useState(false);

  const orderDate =
    order.scheduledDate instanceof Date
      ? order.scheduledDate
      : new Date(order.scheduledDate || Date.now());

  const isValidPhone = (phone) => {
    const cleaned = (phone || '').replace(/\s|-/g, '');
    if (/^\+962/.test(cleaned)) return cleaned.length >= 12;
    if (/^962/.test(cleaned)) return cleaned.length >= 11;
    if (/^0/.test(cleaned)) return cleaned.length >= 9 && cleaned.length <= 10;
    return cleaned.length >= 9 && cleaned.length <= 10;
  };

  const updateOrder = useCallback((updates) => {
    setOrder((prev) => ({ ...prev, ...updates }));
  }, []);

  const goNext = useCallback(() => {
    setCurrentStep((s) => Math.min(s + 1, 5));
  }, []);

  const goBack = useCallback(() => {
    setCurrentStep((s) => Math.max(s - 1, 1));
  }, []);

  const canProceedFromRoute = order.route !== null;
  const canProceedFromService =
    order.service !== null &&
    (order.service.type !== 'instant' || (order.service.description || '').trim());
  const canProceedFromDetails =
    order.fullName.trim() &&
    isValidPhone(order.phoneNumber) &&
    order.pickup &&
    order.destination;

  const buildOrderPayload = useCallback(() => {
    const payload = {
      route: order.route,
      date: orderDate.toISOString(),
      service: formatService(order.service),
      fullName: order.fullName.trim(),
      phoneNumber: order.phoneNumber.trim(),
      pickup: {
        latitude: order.pickup.latitude,
        longitude: order.pickup.longitude,
        address: order.pickup.address,
      },
      destination: {
        latitude: order.destination.latitude,
        longitude: order.destination.longitude,
        address: order.destination.address,
      },
    };
    return payload;
  }, [order, orderDate]);

  const formatService = (service) => {
    if (!service) return null;
    if (service.type === 'basic') return { type: 'basic' };
    if (service.type === 'private') return { type: 'private', alone: service.alone };
    if (service.type === 'airport') return { type: 'airport', toAirport: service.toAirport };
    if (service.type === 'instant') return { type: 'instant', description: service.description };
    return null;
  };

  const submit = useCallback(async () => {
    if (!order.pickup || !order.destination) return;
    setIsSubmitting(true);
    setSubmitError(null);
    try {
      await submitOrder(buildOrderPayload());
      setOrderSent(true);
    } catch (err) {
      setSubmitError(err.message || 'Failed to send. Please try again.');
    } finally {
      setIsSubmitting(false);
    }
  }, [order, buildOrderPayload]);

  const resetOrder = useCallback(() => {
    setOrder(initialOrder);
    setCurrentStep(1);
    setIsSubmitting(false);
    setSubmitError(null);
    setOrderSent(false);
  }, []);

  const value = {
    order,
    updateOrder,
    currentStep,
    goNext,
    goBack,
    setCurrentStep,
    canProceedFromRoute,
    canProceedFromService,
    canProceedFromDetails,
    orderDate,
    isSubmitting,
    submitError,
    orderSent,
    submit,
    resetOrder,
    buildOrderPayload,
    isValidPhone,
  };

  return <OrderContext.Provider value={value}>{children}</OrderContext.Provider>;
}
