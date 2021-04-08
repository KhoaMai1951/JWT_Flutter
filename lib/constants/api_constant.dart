//const String kApiUrl = 'http://10.0.2.2:8000/api/v1';
//if you are using android studio emulator, change localhost to 10.0.2.2

//const String kApiUrl = 'http://192.168.43.165:8000/api/v1';
const String kApiUrl = 'http://192.168.1.2:8000/api/v1';
//// DIGITAL OCEAN
//const String kApiUrl = 'http://143.198.200.30/api/v1';

// AUTHENTICATION SYSTEM
const String kApiRegister = '/register';
const String kApiLogin = '/login';
const String kApiActivateAccount = '/activate_account';
const String kApiLogout = '/logout';
// CHECK TOKEN VALID
const String kApiGetDataWithToken = '/get_data_with_token';

// TAG
const String kApiGetAllTagsByTagTypeId =
    '/tag/get_all_tags_by_type_id?tag_type_id=';
