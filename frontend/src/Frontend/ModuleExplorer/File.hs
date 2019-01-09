{-# LANGUAGE DataKinds              #-}
{-# LANGUAGE DeriveGeneric          #-}
{-# LANGUAGE ExtendedDefaultRules   #-}
{-# LANGUAGE FlexibleContexts       #-}
{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE KindSignatures         #-}
{-# LANGUAGE LambdaCase             #-}
{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE OverloadedStrings      #-}
{-# LANGUAGE QuasiQuotes            #-}
{-# LANGUAGE RecursiveDo            #-}
{-# LANGUAGE ScopedTypeVariables    #-}
{-# LANGUAGE StandaloneDeriving     #-}
{-# LANGUAGE TemplateHaskell        #-}
{-# LANGUAGE TupleSections          #-}
{-# LANGUAGE TypeApplications       #-}
{-# LANGUAGE TypeFamilies           #-}

-- | File abstraction in `ModuleExplorer`.
--
-- Copyright   :  (C) 2018 Kadena
-- License     :  BSD-style (see the file LICENSE)
--

module Frontend.ModuleExplorer.File
  () where

------------------------------------------------------------------------------
import           Data.Map                 (Map)
import qualified Data.Map                 as Map
import           Data.Text                (Text)
import           Generics.Deriving.Monoid (mappenddefault, memptydefault)
import           GHC.Generics             (Generic)
import           Reflex
import           Data.Set                     (Set)
------------------------------------------------------------------------------
import           Obelisk.Generated.Static
import           Pact.Types.Lang          (DefType, FunType, ModuleName, Name,
                                         Term)
------------------------------------------------------------------------------
import           Frontend.Backend
import           Frontend.Foundation
import           Frontend.Wallet
import           Frontend.ModuleExplorer.Example

-- | The name of a file stored by the user.
newtype FileName = FileName { unFileName :: Text }
  deriving (Show, Eq, Ord)

-- | Get textual representation of a `FileName`
textFileName :: FileName -> Text
textFileName = unFileName

-- | A `FileRef` either points to a stored file or an `ExampleRef`.
data FileRef
  = FileRef_Example ExampleRef
  | FileRef_Stored FileName

makePactPrisms ''FileRef

-- | A selected file.
data PactFile = PactFile
  { _pactFile_content :: Text -- * Full content of the file, no matter what.
  , _pactFile_modules :: [Module] -- * Any modules contained in the file. (Parsed content)
  } deriving (Show)

makePactLenses ''PactFile

