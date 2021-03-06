require 'spec_helper'

describe Devise::Oauth2Providable.models.authorization_code do
  describe 'basic authorization code instance' do
    with :client
    subject do
      ABSTRACT(:authorization_code).create! ABSTRACT(:client_sym) => client
    end
    it { should validate_presence_of :token }
    it { should validate_uniqueness_of :token }
    it { should belong_to :user }
    it { should belong_to ABSTRACT(:client_sym) }
    it { should validate_presence_of ABSTRACT(:client_sym) }
    it { should validate_presence_of :expires_at }
    it { should have_db_index ABSTRACT(:client_sym_id) }
    it { should have_db_index :user_id }
    it { should have_db_index(:token).unique(true) }
    it { should have_db_index :expires_at }
  end
end

