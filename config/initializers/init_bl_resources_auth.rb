# frozen_string_literal: true

BlCommons::BlResources.auth_realm = Rails.application.secrets.host || 'REALM'
BlCommons::BlResources.auth_username = 'BlResources'
BlCommons::BlResources.auth_password = BlCommons::BlResources.md5_auth_password(Rails.application.secrets.secret_key_base)
