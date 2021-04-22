import 'dart:convert';

final amplifyConfigMap = {
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0",
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "IdentityManager": {"Default": {}},
        "CredentialsProvider": {
          "CognitoIdentity": {
            "Default": {
              "PoolId": "us-west-2:51fb4d6b-10d4-461e-8172-ac52529b4f2a",
              "Region": "us-west-2"
            }
          }
        },
        "CognitoUserPool": {
          "Default": {
            "PoolId": "us-west-2_GikObR6zU",
            "AppClientId": "6ibudrnjml4p3rc4t9oabvis8o",
            "Region": "us-west-2"
          }
        },
        "Auth": {
          "Default": {
            "authenticationFlowType": "USER_SRP_AUTH"
          }
        }
      }
    },
  },
  "analytics": {
    "plugins": {
      "awsPinpointAnalyticsPlugin": {
        "pinpointAnalytics": {
          "appId": "a9f6d01c8d1f4702a3d75bd063fa4533",
          "region": "us-west-2"
        },
        "pinpointTargeting": {"region": "us-west-2"}
      }
    }
  },
  "storage": {
    "plugins": {
      "awsS3StoragePlugin": {
        "bucket": "scout-spirit-gallery",
        "region": "us-west-2"
      }
    }
  }
};

final String amplifyconfig = jsonEncode(amplifyConfigMap);
