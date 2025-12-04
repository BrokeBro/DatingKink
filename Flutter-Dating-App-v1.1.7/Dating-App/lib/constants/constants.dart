import 'package:flutter/material.dart';

/// APP SETINGS INFO CONSTANTS - SECTION ///
///
const String APP_NAME = "Kink";
const Color APP_PRIMARY_COLOR = Colors.pink;
const Color APP_ACCENT_COLOR = Colors.pinkAccent;
const String APP_VERSION_NAME = "Android v1.0.0 & iOS v1.0.0";
const int ANDROID_APP_VERSION_NUMBER = 1; // Google Play Version Number
const int IOS_APP_VERSION_NUMBER = 1; // App Store Version Number
//
// Add Google Maps - API KEY required for Passport feature
//
const String ANDROID_MAPS_API_KEY = "AIzaSyA1FwY-tRUC0nZB6LZflxSxj86V2Kp90ho";
const String IOS_MAPS_API_KEY = "AIzaSyAbEMy_4-gpDxSBnhViUDDUbo3qvPpZNNI";
//
// GOOGLE ADMOB INTERSTITIAL IDS
//
// For Android Platform
const String ANDROID_INTERSTITIAL_ID = "ca-app-pub-8752796429096336~6154806191";
// For IOS Platform
const String IOS_INTERSTITIAL_ID = "YOUR iOS AD ID";

/// List of Supported Locales
/// Add your new supported Locale to the array list.
///
/// E.g: Locale('fr'), Locale('es'),
///
const List<Locale> SUPPORTED_LOCALES = [Locale('en')];

///
/// END APP SETINGS - SECTION

///
/// DATABASE COLLECTIONS FIELD - SECTION
///
/// FIREBASE MESSAGING TOPIC
const NOTIFY_USERS = "NOTIFY_USERS";

/// DATABASE COLLECTION NAMES USED IN APP
///
const String C_APP_INFO = "AppInfo";
const String C_USERS = "Users";
const String C_FLAGGED_USERS = "FlaggedUsers";
const String C_CONNECTIONS = "Connections";
const String C_MATCHES = "Matches";
const String C_CONVERSATIONS = "Conversations";
const String C_LIKES = "Likes";
const String C_VISITS = "Visits";
const String C_DISLIKES = "Dislikes";
const String C_MESSAGES = "Messages";
const String C_NOTIFICATIONS = "Notifications";
const String C_BLOCKED_USERS = 'BlockedUsers';

/// DATABASE FIELDS FOR AppInfo COLLECTION  ///
///
const String ANDROID_APP_CURRENT_VERSION = "android_app_current_version";
const String IOS_APP_CURRENT_VERSION = "ios_app_current_version";
const String ANDROID_PACKAGE_NAME = "com.brokebro.kink";
const String IOS_APP_ID = "ios_app_id";
const String APP_EMAIL = "app_email";
const String PRIVACY_POLICY_URL = "privacy_policy_url";
const String TERMS_OF_SERVICE_URL = "terms_of_service_url";
const String FIREBASE_SERVER_KEY = "firebase_server_key";
const String STORE_SUBSCRIPTION_IDS = "store_subscription_ids";
const String FREE_ACCOUNT_MAX_DISTANCE = "free_account_max_distance";
const String VIP_ACCOUNT_MAX_DISTANCE = "vip_account_max_distance";
// Admob variables
const String ADMOB_APP_ID = "admob_app_id";
const String ADMOB_INTERSTITIAL_AD_ID = "admob_interstitial_ad_id";

/// DATABASE FIELDS FOR USER COLLECTION  ///
///
const String USER_ID = "user_id";
const String USER_PROFILE_PHOTO = "user_photo_link";
const String USER_FULLNAME = "user_fullname";
const String USER_GENDER = "user_gender";
const String USER_BIRTH_DAY = "user_birth_day";
const String USER_BIRTH_MONTH = "user_birth_month";
const String USER_BIRTH_YEAR = "user_birth_year";
const String USER_SCHOOL = "user_school";
const String USER_JOB_TITLE = "user_job_title";
const String USER_BIO = "user_bio";
const String USER_PHONE_NUMBER = "user_phone_number";
const String USER_EMAIL = "user_email";
const String USER_GALLERY = "user_gallery";
const String USER_COUNTRY = "user_country";
const String USER_LOCALITY = "user_locality";
const String USER_GEO_POINT = "user_geo_point";
const String USER_SETTINGS = "user_settings";
const String USER_STATUS = "user_status";
const String USER_IS_VERIFIED = "user_is_verified";
const String USER_LEVEL = "user_level";
const String USER_REG_DATE = "user_reg_date";
const String USER_LAST_LOGIN = "user_last_login";
const String USER_DEVICE_TOKEN = "user_device_token";
const String USER_TOTAL_LIKES = "user_total_likes";
const String USER_TOTAL_VISITS = "user_total_visits";
const String USER_TOTAL_DISLIKED = "user_total_disliked";
const String USER_KINKS = "user_kinks"; // List of selected kinks
const String USER_VERIFICATION_PHOTO = "user_verification_photo"; // Photo for verification
const String USER_VERIFICATION_STATUS = "user_verification_status"; // pending, verified, rejected
const String USER_AGE_VERIFIED = "user_age_verified"; // true if user confirmed 18+
// User Setting map - fields
const String USER_MIN_AGE = "user_min_age";
const String USER_MAX_AGE = "user_max_age";
const String USER_MAX_DISTANCE = "user_max_distance";
const String USER_SHOW_ME = "user_show_me";
const String USER_FILTER_KINKS = "user_filter_kinks"; // List of kinks to filter by

/// DATABASE FIELDS FOR FlaggedUsers COLLECTION  ///
///
const String FLAGGED_USER_ID = "flagged_user_id";
const String FLAG_REASON = "flag_reason";
const String FLAGGED_BY_USER_ID = "flagged_by_user_id";

/// DATABASE FIELDS FOR Messages and Conversations COLLECTION ///
///
const String MESSAGE_TEXT = "message_text";
const String MESSAGE_TYPE = "message_type";
const String MESSAGE_IMG_LINK = "message_img_link";
const String MESSAGE_READ = "message_read";
const String LAST_MESSAGE = "last_message";

/// DATABASE FIELDS FOR Notifications COLLECTION ///
///
const N_SENDER_ID = "n_sender_id";
const N_SENDER_FULLNAME = "n_sender_fullname";
const N_SENDER_PHOTO_LINK = "n_sender_photo_link";
const N_RECEIVER_ID = "n_receiver_id";
const N_TYPE = "n_type";
const N_MESSAGE = "n_message";
const N_READ = "n_read";

/// DATABASE FIELDS FOR Likes COLLECTION
///
const String LIKED_USER_ID = 'liked_user_id';
const String LIKED_BY_USER_ID = 'liked_by_user_id';
const String LIKE_TYPE = 'like_type';

/// DATABASE FIELDS FOR Dislikes COLLECTION
///
const String DISLIKED_USER_ID = 'disliked_user_id';
const String DISLIKED_BY_USER_ID = 'disliked_by_user_id';

/// DATABASE FIELDS FOR Visits COLLECTION
///
const String VISITED_USER_ID = 'visited_user_id';
const String VISITED_BY_USER_ID = 'visited_by_user_id';

/// DATABASE FIELDS FOR [BlockedUsers] (NEW) COLLECTION
///
const String BLOCKED_USER_ID = 'blocked_user_id';
const String BLOCKED_BY_USER_ID = 'blocked_by_user_id';

/// DATABASE SHARED FIELDS FOR COLLECTION
///
const String TIMESTAMP = "timestamp";

/// KINK CATEGORIES - Comprehensive List ///
///
const List<String> KINK_CATEGORIES = [
  // BDSM & Power Exchange
  'BDSM',
  'Dominant',
  'Submissive',
  'Switch',
  'Master/Slave',
  'Daddy/Mommy Dom',
  'Little',
  'Pet Play',
  'Puppy Play',
  'Kitten Play',
  'Pony Play',
  'Primal',
  'Owner/Property',
  'Service Submissive',
  'Brat',
  'Sadist',
  'Masochist',

  // Bondage & Restraint
  'Bondage',
  'Rope Bondage',
  'Shibari',
  'Handcuffs',
  'Chains',
  'Restraints',
  'Mummification',
  'Predicament Bondage',
  'Sensory Deprivation',

  // Impact Play
  'Spanking',
  'Flogging',
  'Whipping',
  'Paddling',
  'Caning',
  'Impact Play',

  // Roleplay
  'Roleplay',
  'Age Play',
  'Teacher/Student',
  'Boss/Secretary',
  'Doctor/Patient',
  'Cop/Criminal',
  'Stranger Play',
  'Fantasy Roleplay',
  'Cosplay',

  // Fetishes
  'Leather',
  'Latex',
  'PVC',
  'Lingerie',
  'Stockings',
  'High Heels',
  'Boots',
  'Foot Fetish',
  'Shoe Fetish',
  'Pantyhose',
  'Body Worship',
  'Muscle Worship',
  'Ass Worship',

  // Sensory Play
  'Sensory Play',
  'Blindfolds',
  'Wax Play',
  'Ice Play',
  'Temperature Play',
  'Electrostimulation',
  'Tickling',
  'Feathers',

  // Edge Play & Intense
  'Edge Play',
  'Breath Play',
  'Knife Play',
  'Blood Play',
  'Fear Play',
  'Fire Play',

  // Exhibitionism & Voyeurism
  'Exhibitionism',
  'Voyeurism',
  'Public Play',
  'Outdoor Sex',
  'Being Watched',
  'Watching',
  'Dogging',

  // Group & Multiple Partners
  'Threesome',
  'Group Sex',
  'Orgies',
  'Swinging',
  'Hotwife',
  'Cuckold',
  'Polyamory',
  'Open Relationship',

  // Humiliation & Degradation
  'Humiliation',
  'Degradation',
  'Verbal Humiliation',
  'Public Humiliation',
  'Objectification',
  'Human Furniture',

  // Body Modifications
  'Piercings',
  'Tattoos',
  'Body Art',
  'Scarification',

  // Specific Acts
  'Anal Play',
  'Pegging',
  'Strapon',
  'Fisting',
  'Double Penetration',
  'Oral',
  'Deepthroat',
  'Face Sitting',
  'Rimming',

  // Clothing & Dress Up
  'Cross Dressing',
  'Feminization',
  'Sissification',
  'Gender Play',
  'Uniform Fetish',

  // Control & Denial
  'Orgasm Control',
  'Orgasm Denial',
  'Edging',
  'Tease and Denial',
  'Chastity',
  'Ruined Orgasm',
  'Forced Orgasm',

  // Fluids
  'Squirting',
  'Creampie',
  'Cum Play',

  // Discipline & Training
  'Discipline',
  'Training',
  'Punishment',
  'Rules & Protocols',

  // Mental & Psychological
  'Mind Games',
  'Psychological Play',
  'Hypnosis',
  'Consensual Non-Consent',
  'Primal Play',

  // Worship & Devotion
  'Worship',
  'Devotion',
  'TPE (Total Power Exchange)',
  '24/7 Dynamic',

  // Misc
  'Toys',
  'Sex Machines',
  'Glory Hole',
  'Gangbang',
  'Rough Sex',
  'Gentle/Sensual',
  'Tantric Sex',
  'Massage',
  'Erotic Photography',
  'Erotic Art',
  'Phone Sex',
  'Sexting',
  'Virtual Sex',
  'Voice Kink',
  'Dirty Talk',
  'Begging',
  'Praise Kink',
  'Breeding Kink',
  'Pregnancy Kink',
  'Lactation',
  'BBW/BHM',
  'Curves',
  'Athletic',
  'Petite',
  'Tall',
  'Short',
  'Age Gap',
  'Mature/MILF',
  'Silver Fox',
  'Interracial',
  'Hair Pulling',
  'Biting',
  'Scratching',
  'Choking',
  'Gagging',
  'Collaring',
  'Ownership',
  'Aftercare',
  'Safewords',
];

/// GENDER OPTIONS ///
const List<String> GENDER_OPTIONS = ['Male', 'Female', 'Trans'];
