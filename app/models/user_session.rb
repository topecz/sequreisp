# Sequreisp - Copyright 2010, 2011 Luciano Ruete
#
# This file is part of Sequreisp.
#
# Sequreisp is free software: you can redistribute it and/or modify
# it under the terms of the GNU Afero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Sequreisp is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Afero General Public License for more details.
#
# You should have received a copy of the GNU Afero General Public License
# along with Sequreisp.  If not, see <http://www.gnu.org/licenses/>.

class UserSession < Authlogic::Session::Base
  logout_on_timeout true
  consecutive_failed_logins_limit 35
  def self.oauth_consumer
    OAuth::Consumer.new("0EUnt3SWFDKxOuaD0XJz1ajFH3WYc7P2sbBpqzWJ", "QjYCiiqc69uz9ntcbYE4IpoTOVZ5fj65jTyXsM9W",
    { :site=>"http://0.0.0.0:3000",
      :authorize_url => "http://0.0.0.0:3000/oauth/authorize"
    })
  end
end
