#
# Copyright (c) 2016 MasterCard International Incorporated
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are
# permitted provided that the following conditions are met:
#
# Redistributions of source code must retain the above copyright notice, this list of
# conditions and the following disclaimer.
# Redistributions in binary form must reproduce the above copyright notice, this list of
# conditions and the following disclaimer in the documentation and/or other materials
# provided with the distribution.
# Neither the name of the MasterCard International Incorporated nor the names of its
# contributors may be used to endorse or promote products derived from this software
# without specific prior written permission.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
# SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
# TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
# IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
module MasterCard
  module Core
    module Constants
      API_BASE_LIVE_URL       = "https://api.mastercard.com"
      API_BASE_SANDBOX_URL    = "https://sandbox.api.mastercard.com"
    end

    module Environment
      PRODUCTION  = "production"
      SANDBOX     = "sandbox"
      STAGE       = "stage"
      DEV         = "dev"
      MTF         = "mtf"
      ITF         = "itf"
      LOCALHOST   = "localhost"
      DEVCLOUD    = "devcloud"
      LABSCLOUD   = "labscloud"
      OTHER1      = "other1"
      OTHER2      = "other2"
      OTHER3      = "other3"
      MAPPING     = {
          "production" => ["https://api.mastercard.com", nil],
          "sandbox"  => ["https://sandbox.api.mastercard.com", nil],
          "stage"  => ["https://stage.api.mastercard.com", nil],
          "dev"  => ["https://dev.api.mastercard.com", nil],
          "mtf"  => ["https://sandbox.api.mastercard.com", "mtf"],
          "itf"  => ["https://sandbox.api.mastercard.com", "itf"],
          "localhost"  => ["http://localhost:8081", nil]
      }

    end
  end
end
