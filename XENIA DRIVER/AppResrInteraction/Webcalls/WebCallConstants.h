//
//  WebCallConstants.h
//  Restau
//
//  Created by   on 26/07/12.
//  Copyright (c) 2012 vinay@metadesignsolutions.in. All rights reserved.
//
#import "Keys.h"
#ifndef Restau_WebCallConstants_h
#define Restau_WebCallConstants_h
#define APP_DELEGATE (AppDelegate*) [[UIApplication sharedApplication] delegate]


#define APP_WEB_CALLS    (webcall*) [[webcall alloc] init]
#define FONT_HELVETICANEUE_LIGHT(fontSize)                                     \
([UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize])
#define FONT_HELVETICANEUE_BOLD(fontSize)                                      \
([UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize])

#define FONT_HELVETICANEUE_Italic(fontSize)                                     \
([UIFont fontWithName:@"HelveticaNeue-Italic" size:fontSize])
#define FONT_HELVETICANEUE_REGULAR(fontSize)                                   \
([UIFont fontWithName:@"Helvetica Neue" size:fontSize])

#define FONT_ROB_COND_REG(fontSize)                                        \
(UIFont *)[UIFont fontWithName:@"RobotoCondensed-Regular" size:fontSize]

#define FONTS_THEME_BOLD(fontSize)  (UIFont*) [UIFont fontWithName:@"RobotoCondensed-Regular" size:fontSize*(SCREEN_WIDTH/375.0)]
#define FONTS_THEME_REGULAR(fontSize)  (UIFont*) [UIFont fontWithName:@"RobotoCondensed-Regular" size:fontSize*(SCREEN_WIDTH/375.0)]


#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define APP_CallAPI (CallAPI *)[[CallAPI alloc] init]

#define CONSTANT_THEME_COLOR1 [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1]
#define CONSTANT_THEME_COLOR2 [UIColor colorWithRed:252.0/255.0 green:227.0/255.0 blue:3.0/255.0 alpha:1]
#define CONSTANT_TEXT_COLOR_BUTTONS [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1]
#define CONSTANT_TEXT_COLOR_HEADER [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]

static inline NSString *isEmpty(id thing) {
    return (thing == nil || [thing isKindOfClass:[NSNull class]] ||
            ([thing respondsToSelector:@selector(length)] &&
             [(NSData *)thing length] == 0) ||
            ([thing respondsToSelector:@selector(count)] &&
             [(NSArray *)thing count] == 0))
    ? @""
    : thing;
}

#define Share_Text          @"Xeniacoin ICO Pre-sale is on, get 30% bonus for a limited time. Invest in Coal mining/ Altcoins mining. This is a token with with a payout! https://xeniacoin.org"


#define GOOGLE_API_KEY_ROUTE @"AIzaSyAuBMcXjv-39K2SBiWV3wt17SC93yi0XvE"

// DB Common


#define trip_accept                         @"tripapi/tripaccept"   // <<============


#define send_user_notification  @"RiderAndroidIosPushNotification.php"








// APIs
#define google_plus_client @"317874290475-26sr0rrs8m2v2rbham8lbho4fqhq7vg3.apps.googleusercontent.com"


#define current = "myOutput"
#define Email_symbols @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
#define Symbols_text @"~`!@#$%^&*()+=-/;:\"\'{}[]<>^?,™£¢∞§¶•ªº¥€|_.";


//fare amount init
#define accept_time 30
#define price_per_km 5
#define waiting_charge_per_min 1
#define tax 0.05 // 5% (Percentage)
#define driver_mi_charge 5
#define min_percentage_charge 10
#define SIZE 10





#define Numbers_text @"0123456789";
#define alphabets_text @"abcdefghijklmnopqrstuvwxyz";
#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"



//API's
#define GET_USER_PROFILE @"get_user_profile"//@"display_details"
//#define GET_DRIVER_PROFILE @"get_driver_profile"//@"display_details"


//////////////////

//#define DRIVER_SIGNIN @"driver_signin"//@"signin1"
//#define DRIVER_SIGNUP @"driver_signup"//@"signup"
#define DRIVER_SIGNUP @"driverapi/registration"//@"signup"
#define DRIVER_SIGNIN @"driverapi/login"//@"signin1"
#define TRIP_UPDATE @"tripapi/updatetrip"
#define TRIP_GETTRIP @"tripapi/gettrips"
#define CAR_GETCATEGORY @"categoryapi/getcategories"
#define GET_CAR @"carapi/getcars"

#define GET_DRIVER_PROFILE @"driverapi/getdrivers"

#define MAP_ROUTE @"maproute"
#define DRIVER_STATUS @"driverstatus"
#define TRIP_ID @"trip_id"
#define TRIP_STATUS @"trip_status"
#define TRIP_REASON @"trip_reason"
#define TRIP_DISTANCE @"trip_distance"

#define API_GET_TAXI_CONSTANT @"constantapi/getconstants"






#define PAYMENT_SAVE @"save"
#define PAYMENT_GET_PAYMENTS @"getpayments"
#define SET_DRIVER_LOCATION @"set_driver_loc"//@"update_location"
#define GET_USER_LOCATION @"get_user_loc"//@"get_userlocation"

#define GET_WAITING_TIME @"get_request_waiting_duration"//@"GetRequestAcceptDuration"

#define ACCEPT_RIDE @"accept_ride"//@"accept"

#define GET_USER_DROP_LOCATION @"get_user_drop_loc"//@"get_droploc"

#define SET_RIDE_STATS @"set_ride_stats"//@"update_amount"

#define SET_RIDE_STATUS_BEGIN @"set_ride_status_begin"//@"begin_trip"

#define DRIVER_CANCEL_RIDE_REQUEST @"driver_cancel_ride_request"//@"drivercancel_request"

#define UPDATE_DEVICE_TOKEN @"update_driver_device_token"//@"update_devicetoken"

#define CONFIRM_USER_PAY_CASH @"confirm_user_pay_cash"//@"user_details"

#define SET_AVAILABILITY_OFF @"set_driver_availability_off"//@"availability_off"

#define GET_RIDES_HISTORY @"get_rides_history"//@"reviewhistory"

//#define UPDATE_DRIVER_PROFILE @"updated_driver_profile"//@"update_details"

#define UPDATE_DRIVER_PROFILE @"driverapi/updatedriverprofile" //@"update_details"
#define UPDATE_DRIVER_PASSWORD @"driverapi/updatedriverpassword"//@"update_details"

#define DRIVER_CHANGE_PASSWORD @"driverapi/forgetpassword"//@"reset_pwd"



#define GET_RIDE_AMOUNT_CALCULATED @"get_ride_amount_calc"//@"get_amount"

#define PROMO_PAY_ACCEPT @"accept_payment_promo"

//#define GET_USERS_NEARBY @"get_users_nearby"//@"near_by_users"
#define GET_USERS_NEARBY @"userapi/getnearbyuserlists"//@"near_by_users"

#define CANCEL_INTENTIONALLY @"set_request_cancel_intentionally"//@"cancelreq_intentionally"


#define  TS_REQUEST          @"request"
#define  TS_REJECTED         @"rejected"
#define  TS_ACCEPTED         @"accept"
#define  TS_END              @"end"
#define  TS_ARRIVE           @"arrive"
#define  TS_BEGIN            @"begin"
#define  TS_DRIVER_CANCEL    @"driver_cancel"
#define  TS_DRIVER_CANCEL_AT_PICKUP    @"driver_cancel_at_pickup"
#define  TS_DRIVER_CANCEL_AT_DROP    @"driver_cancel_at_drop"
#define  TS_PAID             @"Paid"
#define  PAY_ACCEPTED        @"payaccept"
#define  TS_WAITING          @"waiting"
#define  TS_PICKED           @"Picked"
#define  PAYPAL_PAY          @"PayPal"
#define  CASH_PAY            @"Cash"


//side Menu
#define SIDE_MENU_LOGOUT        @"power-button"
#define SIDE_MENU_TERMS         @"terms_condition"
#define SIDE_MENU_SHARE         @"share"
#define SIDE_MENU_DEACTIVATE    @"deactivate"
#define SIDE_MENU_SUPPORT       @"support"



//TRIP MESSAGES
//#define  MESSAGE_REQUEST          @"You got a taxi request"
#define  MESSAGE_REJECTED         @"Driver has rejected taxi request"
#define  MESSAGE_ACCEPTED         @"Your taxi request is confirmed"
#define  MESSAGE_END              @"Your trip is finished"
#define  MESSAGE_ARRIVE           @"Taxi will arrive soon"
#define  MESSAGE_BEGIN            @"Your trip has started"
#define  MESSAGE_DRIVER_CANCEL    @"Driver has cancelled trip"
#define  MESSAGE_PAID             @"You have paid successfully"
#define MESSAGE_CASH              @"Please collect cash from Rider."
#define MESSAGE_PAYPAL            @"Rider is paying through paypal"


#define MESSAGE_DEACTIVATE        @"Account_Hold"

// string contants

#define P_STATUS @"status"
#define P_RESPONSE @"response"
#define P_STATUS_OK @"OK"
#define P_MESSAGE @"message"
#define P_ERROR @"error"

#define P_FAVOURITE_DEALS @"favourite"

// LOGIN
#define P_ADDRESS @"address"
#define P_CITY @"City"
#define P_COUNTRY @"Country"
#define P_EMAIL @"d_email"
#define P_USER_ID @"id"
#define P_PASSWORD @"d_password"
#define P_NEW_PASSWORD @"new_password"
#define P_DRIVER_LAT @"d_lat"
#define P_DRIVER_LNG @"d_lng"

#define P_MOBILE @"d_phone"
#define P_STATE @"state"
#define P_STATUS @"status"
#define P_TOKEN @"token"
#define P_USERNAME @"username"
#define P_ZIP @"u_zipcode"
#define P_FNAME @"d_fname"
#define P_DRIVER_ID @"driver_id"
#define P_DRIVER_INSURANCE @"driver_insurance"
#define P_DRIVER_PROFILE_IMAGE_PATH @"d_profile_image_path"
#define P_DRIVER_INSURANCE_IMAGE_PATH @"d_insurance_image_path"
#define P_NAME @"d_name"
#define P_LNAME @"d_lname"
#define P_DRIVER_AVAILAILITY @"d_is_available"
#define P_DRIVER_VERIFIED    @"d_is_verified"


#define P_CAR_MAKE @"car_make"
#define P_CAR_MODEL @"car_name"
#define P_CAR_YEAR @"car_model"
#define P_CAR_LICENSE_NUMBER @"car_reg_no"


#define P_GENDER @"gender"
#define P_API_KEY @"api_key"
#define P_DEVICE_TOKEN @"d_device_token"
#define P_DEVICE_TYPE @"d_device_type"
#define P_CATEGORY_ID @"category_id"

#define P_CATEGORY_BASE_PRICE  @"cat_base_price"
#define P_CATEGORY_FARE_PER_KM  @"cat_fare_per_km"
#define P_CATEGORY_FARE_PER_MIN @"cat_fare_per_min"
#define P_CATEGORY_IS_FIXED_PRICE @"cat_is_fixed_price"
#define P_CATEGORY_PRIME_TIME_PERCENTAGE @"cat_prime_time_percentage"


#define P_CAR_ID @"car_id"
#define P_CAR_NAME @"car_name"
#define P_CAT_NAME @"cat_name"
#define P_DRIVER_RC @"driver_rc"
#define P_DRIVER_LIC @"driver_license"
#define P_DRIVER_RC_IMAGE_PATH @"d_rc_image_path"
#define P_DRIVER_LIC_IMAGE_PATH @"d_license_image_path"
#define P_USER_DICT @"user_dict"
#define P_CATEGORY_NAME         @"cat_name"
#define P_IS_SHOW_EXTRA_POPUP @"Yes"








#endif


