{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Web.Plaid.Types where

import Data.Aeson
import qualified Data.Map as M
import Data.Text (Text)
import Data.Time (Day)
import GHC.Generics

import Web.Plaid.Internal
import Web.Plaid.Types.Core

-- | Request body to exchange token. Example below:
-- @
-- {
--   "client_id": String,
--   "secret": String,
--   "public_token": "public-sandbox-5c224a01-8314-4491-a06f-39e193d5cddc"
-- }
-- @
data ExchangeTokenRequest = ExchangeTokenRequest
  { _exchangeTokenRequest_clientId :: Text
  , _exchangeTokenRequest_secret :: Text
  , _exchangeTokenRequest_publicToken :: Text
  }
  deriving (Eq, Generic, Show)

-- | Response body of exchanging token. Example below:
-- @
-- {
--   "access_token": "access-sandbox-de3ce8ef-33f8-452c-a685-8671031fc0f6",
--   "item_id": "M5eVJqLnv3tbzdngLDp9FL5OlDNxlNhlE55op",
--   "request_id": "Aim3b"
-- }
-- @
data ExchangeTokenResponse = ExchangeTokenResponse
  { _exchangeTokenResponse_accessToken :: Text
  , _exchangeTokenResponse_itemId :: Text
  , _exchangeTokenResponse_requestId :: Text
  }
  deriving (Eq, Generic, Show)

-- | Request body to get transactions. Example below:
-- {
--   "client_id": "5a8dd7dabdc6a47debd6efcf",
--   "secret": "fe1eeaf6119031b8bd76831b31cf6b",
--   "access_token": "access-sandbox-4754080b-79fd-482b-8fb4-0f4ce80b6158",
--   "start_date": "2017-01-01",
--   "end_date": "2017-02-01",
--   "options": {
--     "count": 250,
--     "offset": 100
--   }
-- }
data TransactionsRequest = TransactionsRequest
  { _transactionsRequest_clientId :: Text
  , _transactionsRequest_secret :: Text
  , _transactionsRequest_accessToken :: Text
  , _transactionsRequest_startDate :: Date
  , _transactionsRequest_endDate :: Date
  , _transactionsRequest_options :: PaginationOptions
  }
  deriving (Eq, Generic, Show)

data PaginationOptions = PaginationOptions
  { _paginationOptions_count :: Int
  , _paginationOptions_offset :: Int
  }
  deriving (Eq, Generic, Show)

-- | Response body of getting transactions. Example below
-- @
-- {
-- "accounts":[ ...
-- ],
-- "item":{ ...
-- },
-- "request_id": "Bo40m",
-- "total_transactions": 16,
-- "transactions":[]
-- }
-- @
data TransactionsResponse = TransactionsResponse
  { _transactionsResponse_accounts :: [Account]
  , _transactionsResponse_item :: Item
  , _transactionsResponse_requestId :: Text
  , _transactionsResponse_totalTransactions :: Int
  , _transactionsResponse_transactions :: [Transaction]
  }
  deriving (Eq, Generic, Show)

-- | A transaction. Example below
-- {
--     "account_id": "vokyE5Rn6vHKqDLRXEn5fne7LwbKPLIXGK98d",
--     "amount": 2307.21,
--     "category": [
--       "Shops",
--       "Computers and Electronics"
--     ],
--     "category_id": "19013000",
--     "date": "2017-01-29",
--     "location": {
--      "address": "300 Post St",
--      "city": "San Francisco",
--      "state": "CA",
--      "zip": "94108",
--      "lat": null,
--      "lon": null
--     },
--     "name": "Apple Store",
--     "payment_meta": Object,
--     "pending": false,
--     "pending_transaction_id": null,
--     "account_owner": null,
--     "transaction_id": "lPNjeW1nR6CDn5okmGQ6hEpMo4lLNoSrzqDje",
--     "transaction_type": "place"
-- }
data Transaction = Transaction
  { _transaction_accountId :: Text
  , _transaction_amount :: Money
  , _transaction_category :: Maybe [Text]
  , _transaction_categoryId :: Maybe Text
  , _transaction_date :: Date
  , _transaction_location :: Location
  , _transaction_name :: Text
  , _transaction_paymentMeta :: M.Map Text (Maybe Text)
  , _transaction_pending :: Bool
  , _transaction_pendingTransactionId :: Maybe Text
  , _transaction_accountOwner :: Maybe Text
  , _transaction_transactionId :: Text
  , _transaction_transactionType :: Text
  }
  deriving (Eq, Generic, Show)

data Location = Location
  { _location_address :: Maybe Text
  , _location_city :: Maybe Text
  , _location_state :: Maybe Text
  , _location_zip :: Maybe Text
  , _location_lat :: Maybe Text
  , _location_lon :: Maybe Text
  }
  deriving (Eq, Generic, Show)

-- | An account type. Example below:
-- {
-- "account_id": "6zPbKj8wa8c6pqXxA3pLCqZMelWXlLfjP1rND",
-- "balances":{"available": 200, "current": 210, "limit": null},
-- "mask": "1111",
-- "name": "Plaid Saving",
-- "official_name": "Plaid Silver Standard 0.1% Interest Saving",
-- "subtype": "savings",
-- "type": "depository"
-- },
data Account = Account
  { _account_accountId :: Text
  , _account_balances :: Balances
  , _account_mask :: Text
  , _account_name :: Text
  , _account_officialName :: Text
  , _account_subtype :: Text
  , _account_type :: Text
  }
  deriving (Eq, Generic, Show)

data Balances = Balances
  { _balances_available :: Maybe Money
  , _balances_current :: Money
  , _balances_limit :: Maybe Money
  }
  deriving (Eq, Generic, Show)

-- | An item. Example below
-- {
-- "available_products":[
-- "balance"
-- ],
-- "billed_products":[
-- "transactions"
-- ],
-- "error": null,
-- "institution_id": "ins_107039",
-- "item_id": "nKPQWazXyzc45mWZ8K5gSvDA9aodEMix9xM63",
-- "webhook": ""
-- }
data Item = Item
  { _item_availableProducts :: [Text]
  , _item_billedProducts :: [Text]
  , _item_error :: Maybe Text
  , _item_institutionId :: Text
  , _item_itemId :: Text
  , _item_webhook :: Text
  }
  deriving (Eq, Generic, Show)

instance FromJSON Config where
  parseJSON = genericParseJSON fieldLabelMod
instance FromJSON ExchangeTokenRequest where
  parseJSON = genericParseJSON fieldLabelMod
instance FromJSON ExchangeTokenResponse where
  parseJSON = genericParseJSON fieldLabelMod
instance FromJSON TransactionsRequest where
  parseJSON = genericParseJSON fieldLabelMod
instance FromJSON PaginationOptions where
  parseJSON = genericParseJSON fieldLabelMod
instance FromJSON TransactionsResponse where
  parseJSON = genericParseJSON fieldLabelMod
instance FromJSON Transaction where
  parseJSON = genericParseJSON fieldLabelMod
instance FromJSON Location where
  parseJSON = genericParseJSON fieldLabelMod
instance FromJSON Account where
  parseJSON = genericParseJSON fieldLabelMod
instance FromJSON Balances where
  parseJSON = genericParseJSON fieldLabelMod
instance FromJSON Item where
  parseJSON = genericParseJSON fieldLabelMod

instance ToJSON Config where
  toJSON = genericToJSON fieldLabelMod
instance ToJSON ExchangeTokenRequest where
  toJSON = genericToJSON fieldLabelMod
instance ToJSON ExchangeTokenResponse where
  toJSON = genericToJSON fieldLabelMod
instance ToJSON TransactionsRequest where
  toJSON = genericToJSON fieldLabelMod
instance ToJSON PaginationOptions where
  toJSON = genericToJSON fieldLabelMod
instance ToJSON TransactionsResponse where
  toJSON = genericToJSON fieldLabelMod
instance ToJSON Transaction where
  toJSON = genericToJSON fieldLabelMod
instance ToJSON Location where
  toJSON = genericToJSON fieldLabelMod
instance ToJSON Account where
  toJSON = genericToJSON fieldLabelMod
instance ToJSON Balances where
  toJSON = genericToJSON fieldLabelMod
instance ToJSON Item where
  toJSON = genericToJSON fieldLabelMod
