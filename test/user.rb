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
        class User < MasterCard::Core::Model::BaseObject
            include MasterCard::Core::Model
            #

            @__store = {
                'bc2db01d-cf66-4050-a9af-4a6c67a5a7be' => OperationConfig.new("/mock_crud_server/users", "list", [], []),
                'e53e61ff-ffa8-4d6f-9e2b-e85bfc70609a' => OperationConfig.new("/mock_crud_server/users", "create", [], []),
                '989b48f8-87d2-4551-928e-441e3cc3a1ff' => OperationConfig.new("/mock_crud_server/users/{id}", "read", [], []),
                'b39fbd58-cbf0-48ba-9971-e05101ec2309' => OperationConfig.new("/mock_crud_server/users/{id}", "update", [], []),
                '54f33e70-0c93-472a-8369-b45c59ae11cb' => OperationConfig.new("/mock_crud_server/users/{id}", "delete", [], []),

            }

            protected

            def self.getOperationConfig(uuid)
                if @__store.key?(uuid)
                    return @__store[uuid]
                end
                raise NotImplementedError.new("Invalid operationUUID supplied:"+ uuid)
            end

            def self.getOperationMetadata()
                return OperationMetadata.new("0.0.1", "http://localhost:8081")
            end

            public






            def self.listByCriteria(criteria = nil)
                #
                #List objects of type User
                #
                #@param Dict criteria
                #@return Array of User object matching the criteria.

                if criteria.nil?
                    return self.execute("bc2db01d-cf66-4050-a9af-4a6c67a5a7be",User.new)
                else
                    return self.execute("bc2db01d-cf66-4050-a9af-4a6c67a5a7be",User.new(criteria))
                end
            end





            def self.create(mapObj)
                #
                #Creates object of type User
                #
                #@param Dict mapObj, containing the required parameters to create a new object
                #@return User of the response of created instance.
                #
                return self.execute("e53e61ff-ffa8-4d6f-9e2b-e85bfc70609a", User.new(mapObj))
            end













            def self.read(id, criteria = nil)
                #
                #Returns objects of type User by id and optional criteria
                #@param str id
                #@param dict criteria
                #@return instance of User

                mapObj = User.new
                mapObj.set("id", id)
                if !criteria.nil?
                    mapObj.setAll(criteria)
                end

                return self.execute("989b48f8-87d2-4551-928e-441e3cc3a1ff",User.new(mapObj))
            end




            def update
                #
                #Updates an object of type User
                #
                #@return User object representing the response.
                #
                return self.class.execute("b39fbd58-cbf0-48ba-9971-e05101ec2309",self)
            end










            def self.deleteById(id, map = nil)
                #Delete object of type User by id

                #@param str id
                #@param Dict map, containing additional parameters
                #@return User of the response of the deleted instance.

                mapObj = User.new
                mapObj.set("id", id)
                if !map.nil?
                    mapObj.setAll(map)
                end

                return self.execute("54f33e70-0c93-472a-8369-b45c59ae11cb", mapObj)
            end


            def delete
                #
                #Delete object of type User

                #@param str id
                #@return User of the response of the deleted instance.
                #
                return self.class.execute("54f33e70-0c93-472a-8369-b45c59ae11cb", self)
            end
        end
    end
end







