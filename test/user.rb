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
                    '6ac0b4ea-c45d-490b-96a5-840c4f8415e8' => OperationConfig.new("/mock_crud_server/users", "list", [], []),
                    'df06a6ca-4345-46e7-957c-0905dc51cb8d' => OperationConfig.new("/mock_crud_server/users", "create", [], []),
                    'f481fe9b-e21a-4ff5-8796-8fd5cad980fc' => OperationConfig.new("/mock_crud_server/users/{id}", "read", [], []),
                    '79c5ec39-b816-421f-87da-a51fcbbe0ca0' => OperationConfig.new("/mock_crud_server/users/{id}", "update", [], []),
                    'f3acd077-7a77-45db-90b2-d966bf408731' => OperationConfig.new("/mock_crud_server/users/{id}", "delete", [], []),
                    'cb334878-e880-4940-ab10-29b89e171d90' => OperationConfig.new("/mock_crud_server/users200/{id}", "delete", [], []),
                    '0049f449-4c7c-416e-aa5f-c3208ead83f6' => OperationConfig.new("/mock_crud_server/users204/{id}", "delete", [], []),
                    
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
                        return self.execute("6ac0b4ea-c45d-490b-96a5-840c4f8415e8",User.new)
                    else
                        return self.execute("6ac0b4ea-c45d-490b-96a5-840c4f8415e8",User.new(criteria))
                    end
                end



                def self.create(mapObj)
                    #
                    #Creates object of type User
                    #
                    #@param Dict mapObj, containing the required parameters to create a new object
                    #@return User of the response of created instance.
                    #
                    return self.execute("df06a6ca-4345-46e7-957c-0905dc51cb8d", User.new(mapObj))
                end










                def self.read(id, criteria = nil)
                    #
                    #Returns objects of type User by id and optional criteria
                    #@param str id
                    #@param dict criteria
                    #@return instance of User

                    mapObj = User.new
                    if !(id.nil? || id.to_s.empty?)
                      mapObj.set("id", id)
                    end
                    if !criteria.nil?
                        if criteria.instance_of? RequestMap
                          mapObj.setAll(criteria.getObject())
                        else
                          mapObj.setAll(criteria)
                        end
                    end

                    return self.execute("f481fe9b-e21a-4ff5-8796-8fd5cad980fc",User.new(mapObj))
                end



                def update
                    #
                    #Updates an object of type User
                    #
                    #@return User object representing the response.
                    #
                    return self.class.execute("79c5ec39-b816-421f-87da-a51fcbbe0ca0",self)
                end









                def self.deleteById(id, map = nil)
                    #Delete object of type User by id

                    #@param str id
                    #@param Dict map, containing additional parameters
                    #@return User of the response of the deleted instance.


                    mapObj = User.new
                    if !(id.nil? || id.to_s.empty?)
                      mapObj.set("id", id)
                    end
                    if !map.nil?
                        if map.instance_of? RequestMap
                          mapObj.setAll(map.getObject())
                        else
                          mapObj.setAll(map)
                        end
                    end

                    return self.execute("f3acd077-7a77-45db-90b2-d966bf408731", mapObj)
                end


                def delete
                    #
                    #Delete object of type User

                    #@param str id
                    #@return User of the response of the deleted instance.
                    #

                    return self.class.execute("f3acd077-7a77-45db-90b2-d966bf408731", self)
                end






                def self.delete200ById(id, map = nil)
                    #Delete object of type User by id

                    #@param str id
                    #@param Dict map, containing additional parameters
                    #@return User of the response of the deleted instance.


                    mapObj = User.new
                    if !(id.nil? || id.to_s.empty?)
                      mapObj.set("id", id)
                    end
                    if !map.nil?
                        if map.instance_of? RequestMap
                          mapObj.setAll(map.getObject())
                        else
                          mapObj.setAll(map)
                        end
                    end

                    return self.execute("cb334878-e880-4940-ab10-29b89e171d90", mapObj)
                end


                def delete200
                    #
                    #Delete object of type User

                    #@param str id
                    #@return User of the response of the deleted instance.
                    #

                    return self.class.execute("cb334878-e880-4940-ab10-29b89e171d90", self)
                end






                def self.delete204ById(id, map = nil)
                    #Delete object of type User by id

                    #@param str id
                    #@param Dict map, containing additional parameters
                    #@return User of the response of the deleted instance.


                    mapObj = User.new
                    if !(id.nil? || id.to_s.empty?)
                      mapObj.set("id", id)
                    end
                    if !map.nil?
                        if map.instance_of? RequestMap
                          mapObj.setAll(map.getObject())
                        else
                          mapObj.setAll(map)
                        end
                    end

                    return self.execute("0049f449-4c7c-416e-aa5f-c3208ead83f6", mapObj)
                end


                def delete204
                    #
                    #Delete object of type User

                    #@param str id
                    #@return User of the response of the deleted instance.
                    #

                    return self.class.execute("0049f449-4c7c-416e-aa5f-c3208ead83f6", self)
                end

        end
    end
end







