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


require "mastercard/core/model"

module MasterCard
    module Test
        class Machine < MasterCard::Core::Model::BaseObject
            include MasterCard::Core::Model
            #

            @__store = {
                'd654a774-a835-4852-ab25-7ba879ab050b' => OperationConfig.new("/vending-sandbox-api/api/v1/machine/nearby", "list", [], ["latitude","longitude"]),

            }

            protected

            def self.getOperationConfig(uuid)
                if @__store.key?(uuid)
                    return @__store[uuid]
                end
                raise NotImplementedError.new("Invalid operationUUID supplied:"+ uuid)
            end

            def self.getOperationMetadata()
                return OperationMetadata.new("0.0.1", "https://www.mastercardlabs.com")
            end

            public



            def self.listByCriteria(criteria = nil)
                #
                #List objects of type Machine
                #
                #@param Dict criteria
                #@return Array of Machine object matching the criteria.

                if criteria.nil?
                    return self.execute("d654a774-a835-4852-ab25-7ba879ab050b",Machine.new)
                else
                    return self.execute("d654a774-a835-4852-ab25-7ba879ab050b",Machine.new(criteria))
                end
            end
        end
    end
end







