
require 'active_record'   ## todo: add sqlite3? etc.
require 'sqlite3'
require 'cocos'


## pull-in footballdata
require 'footballdb-data'


## our own code
##  note - a copy of  'lib/sportdb/indexers/models' !!!!!
require_relative 'fbcat/models'


Country          = CatalogDb::Model::Country
CountryName      = CatalogDb::Model::CountryName
Club             = CatalogDb::Model::Club
ClubName         = CatalogDb::Model::ClubName
NationalTeam     = CatalogDb::Model::NationalTeam
NationalTeamName = CatalogDb::Model::NationalTeamName
League           = CatalogDb::Model::League
LeagueName       = CatalogDb::Model::LeagueName
LeaguePeriod     = CatalogDb::Model::LeaguePeriod



