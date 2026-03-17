import AsyncStorage from '@react-native-async-storage/async-storage';

const en = {
  route_irbid_to_amman: 'Irbid → Amman',
  route_amman_to_irbid: 'Amman → Irbid',
  choose_route: 'Choose your route',
  next: 'Next',
  back: 'Back',
  today: 'Today',
  scheduled: 'Scheduled',
  select_date: 'Select date',
  select_time: 'Select pickup time',
  choose_date: 'Choose when you need the ride',
  pickup_time: 'Pickup time',
  service_basic: 'Basic Ride',
  service_basic_desc: '5 JOD per person',
  service_private: 'Private Ride',
  service_private_desc: '15 JOD - just you or your family',
  alone: 'Alone',
  family: 'Family (2-4 people)',
  service_airport: 'Airport Service',
  service_airport_desc: 'To or from Queen Alia Airport',
  to_airport: 'To Airport',
  from_airport: 'From Airport',
  service_instant: 'Instant Order',
  service_instant_desc: 'Transport of items (not people)',
  what_to_transport: 'What do you want to transport?',
  enter_description: 'Describe the items...',
  choose_service: 'Choose your service',
  jod: 'JOD',
  pickup_location: 'Pickup location',
  destination: 'Destination',
  use_my_location: 'Use my location',
  choose_location: 'Choose on map',
  full_name: 'Full name',
  phone_number: 'Phone number',
  enter_full_name: 'Enter your full name',
  enter_phone: 'e.g. 07X XXX XXXX',
  search_address: 'Search address',
  enter_address: 'e.g. Irbid, Amman, or full address',
  set_address: 'Set address',
  traffic: 'Traffic',
  your_details: 'Your details',
  order_summary: 'Order summary',
  submit_order: 'Submit Order',
  order_sent: 'Order sent!',
  order_sent_desc: 'The owner will contact you shortly.',
  new_order: 'New Order',
  step: 'Step',
  step_of: '%1 of %2',
  error_required: 'This field is required',
  error_invalid_phone: 'Enter a valid Jordan phone number',
  error_select_location: 'Please select a location',
  error_geocode_failed: 'Could not find this address. Try a different format or use "Use my location".',
  sending: 'Sending...',
  error_sending: 'Failed to send. Please try again.',
  cancel: 'Cancel',
  done: 'Done',
  confirm: 'Confirm',
};

const ar = {
  route_irbid_to_amman: 'إربد → عمان',
  route_amman_to_irbid: 'عمان → إربد',
  choose_route: 'اختر مسارك',
  next: 'التالي',
  back: 'رجوع',
  today: 'اليوم',
  scheduled: 'مجدول',
  select_date: 'اختر التاريخ',
  select_time: 'اختر وقت الانطلاق',
  choose_date: 'متى تحتاج الرحلة؟',
  pickup_time: 'وقت الانطلاق',
  service_basic: 'رحلة أساسية',
  service_basic_desc: '5 دينار للشخص',
  service_private: 'رحلة خاصة',
  service_private_desc: '15 دينار - وحدك أو مع عائلتك',
  alone: 'وحدك',
  family: 'عائلة (2-4 أشخاص)',
  service_airport: 'خدمة المطار',
  service_airport_desc: 'من أو إلى مطار الملكة علياء',
  to_airport: 'إلى المطار',
  from_airport: 'من المطار',
  service_instant: 'طلب فوري',
  service_instant_desc: 'نقل أشياء (ليس أشخاص)',
  what_to_transport: 'ماذا تريد نقل؟',
  enter_description: 'صف المحتويات...',
  choose_service: 'اختر الخدمة',
  jod: 'د.أ',
  pickup_location: 'موقع الانطلاق',
  destination: 'الوجهة',
  use_my_location: 'استخدام موقعي',
  choose_location: 'اختر على الخريطة',
  full_name: 'الاسم الكامل',
  phone_number: 'رقم الهاتف',
  enter_full_name: 'أدخل اسمك الكامل',
  enter_phone: 'مثال: 07X XXX XXXX',
  search_address: 'ابحث عن عنوان',
  enter_address: 'مثال: إربد، عمان، أو العنوان الكامل',
  set_address: 'تأكيد العنوان',
  traffic: 'المرور',
  your_details: 'بياناتك',
  order_summary: 'ملخص الطلب',
  submit_order: 'إرسال الطلب',
  order_sent: 'تم إرسال الطلب!',
  order_sent_desc: 'سيتواصل معك صاحب الخدمة قريباً.',
  new_order: 'طلب جديد',
  step: 'خطوة',
  step_of: '%1 من %2',
  error_required: 'هذا الحقل مطلوب',
  error_invalid_phone: 'أدخل رقم هاتف أردني صحيح',
  error_select_location: 'الرجاء اختيار الموقع',
  error_geocode_failed: 'لم يتم العثور على هذا العنوان. جرب صيغة مختلفة أو استخدم "استخدام موقعي".',
  sending: 'جاري الإرسال...',
  error_sending: 'فشل الإرسال. حاول مرة أخرى.',
  cancel: 'إلغاء',
  done: 'تم',
  confirm: 'تأكيد',
};

const translations = { en, ar };
let currentLocale = 'ar';

const i18n = {
  locale: 'ar',
  t: (key) => {
    const t = translations[currentLocale] || translations.ar;
    return t[key] || translations.en[key] || key;
  },
};

const STORAGE_KEY = 'app_language';

export const setLanguage = async (lang) => {
  currentLocale = lang;
  i18n.locale = lang;
  try {
    await AsyncStorage.setItem(STORAGE_KEY, lang);
  } catch (e) {}
};

export const getStoredLanguage = async () => {
  try {
    const stored = await AsyncStorage.getItem(STORAGE_KEY);
    return stored || 'ar';
  } catch {
    return 'ar';
  }
};

export const initI18n = async () => {
  try {
    const stored = await getStoredLanguage();
    currentLocale = stored;
    i18n.locale = stored;
    return stored;
  } catch {
    return 'ar';
  }
};

export default i18n;
