library service_url;

const String domain = 'http://192.168.1.102:5001/api';

const String registerDriver = '$domain/auth/driver/register';
const String loginDriver = '$domain/auth/driver/login';
const String getUserData = '$domain/auth/getUserProfile';

const String updateVehicle = '$domain/update/driver/vehicle';
const String updateFcmToken = '$domain/update/driver/fcmtoken';
const String updateDriverAvailability = '$domain/update/driver/status';

const String acceptNewTrip = '$domain/trips/addTrip';