class ApiUrl {
  //BASE URl
  static String baseUrl = "https://backend-ooglemate.caroogle.it/";
  //"https://backend.ooglemate.codesorbit.net/";

  //AUTHENTICATION
  static String loginInUrl = "${baseUrl}api/users/login";
  static String signUpUrl = "${baseUrl}api/users/signup";
  static String forgetPasswordUrl = "${baseUrl}api/users/forgot_password";
  static String socialLoginUrl = "${baseUrl}api/users/social_login";
  static String loginOutUrl = "${baseUrl}api/users/logout";

  //SUBSCRIPTION URL
  static String getPlanUrl = "${baseUrl}api/users/get_plans";
  static String createCheckOutUrl =
      "${baseUrl}api/subscriptions/create_checkout";
  static String getActivePlanUrl =
      "${baseUrl}api/subscriptions/active_subscription";
  static String cancelSubscriptionUrl =
      "${baseUrl}api/subscriptions/cancel_subscription";
  static String historyUrl = "${baseUrl}api/subscriptions/history?";
  static String changeSubscriptionUrl =
      "${baseUrl}api/subscriptions/change_subscription";
  static String subscriptionSettingUrl = "${baseUrl}api/users/settings";

  // PROFILE URL
  static String getProfileUrl = "${baseUrl}api/users/profile";
  static String updateProfileUrl = "${baseUrl}api/users/update_profile";
  static String appNotificationUrl =
      "${baseUrl}api/users/notifications/enable_disable";

  //HOME
  static String getSourceUrl = "${baseUrl}api/users/get_sources";
  static String carDetailUrl = "${baseUrl}api/users/car_details";
  static String ratePredictUrl = "${baseUrl}api/users/rate_predict";
  static String markAsPurchaseUrl = "${baseUrl}api/users/mark_as_purchase";
  static String markAsFavouriteUrl = "${baseUrl}api/users/mark_as_favourite";
  static String getRecommendationUrl = "${baseUrl}api/users/recommendations";
  static String getAllMatchesUrl = "${baseUrl}api/users/all_matches";

  // David RECOMMENDATION
  static String getDavidRecommendationUrl =
      "${baseUrl}api/users/david_recommendations";

  // DROPDOWN
  static String getMakeUrl = "${baseUrl}api/users/makes";
  static String getModelUrl = "${baseUrl}api/users/models/";
  static String getTransmissionUrl = "${baseUrl}api/users/transmissions";
  static String getColorUrl = "${baseUrl}api/users/exterior_colors";
  static String getFuelTypeUrl = "${baseUrl}api/users/fuel_types";
  static String getBodyTypeUrl = "${baseUrl}api/users/body_types";

  //PREFERENCES
  static String downloadCsvUrl = "${baseUrl}api/users/sample_csv";
  static String uploadCsvUrl = "${baseUrl}api/users/preferences/upload_csv";
  static String csvMappingUrl = "${baseUrl}api/users/preferences/csv_mapping";
  static String addPreferencesUrl = "${baseUrl}api/users/preferences/add_new";
  static String enableDisableSinglePreferencesUrl =
      "${baseUrl}api/users/preferences/enable_disable";
  static String enableDisableAllPreferencesUrl =
      "${baseUrl}api/users/preferences/enable_disable/all";
  static String getAllPreferencesUrl = "${baseUrl}api/users/preferences/all";
  static String carInPreferencesUrl = "${baseUrl}api/users/preferences/cars";
  static String deleteAllPreferencesUrl =
      "${baseUrl}api/users/preferences/delete_all";
  static String deleteSinglePreferencesUrl = "${baseUrl}api/users/preferences/";

  //TRACK
  static String allTrackUrl = "${baseUrl}api/users/track";
  static String deleteTrackUrl = "${baseUrl}api/users/track";
  static String setTrackUrl = "${baseUrl}api/users/track";

  //TRIGGER
  static String allTriggerUrl = "${baseUrl}api/users/triggers";
  static String carinTriggerUrl = "${baseUrl}api/users/triggers/cars";
  static String addNewTriggerUrl = "${baseUrl}api/users/triggers";
  static String deleteTriggerUrl = "${baseUrl}api/users/triggers/";

  //INVENTORIES
  static String allInventoriesUrl = "${baseUrl}api/users/inventories";
  static String addNewInventoriesUrl = "${baseUrl}api/users/inventories";
  static String similarCarInventoriesUrl = "${baseUrl}api/users/similar_cars/";
  static String markAsSoldUrl = "${baseUrl}api/users/inventories/mark_as_sold";
  static String uploadInventoryCsvUrl =
      "${baseUrl}api/users/inventories/upload_csv";
  static String inventoryMappingUrl =
      "${baseUrl}api/users/inventories/csv_mapping";

  //FAVOURITES
  static String favouritesUrl = "${baseUrl}api/users/favourites";

  //NOTIFICATION
  static String getNotificationUrl = "${baseUrl}api/users/notifications";

  //GLOBAL SEARCH
  static String globalSearchUrl = "${baseUrl}api/users/get_ads_fact";
}
