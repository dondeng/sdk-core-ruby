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
        class MultiplePathUserPost < MasterCard::Core::Model::BaseObject
            include MasterCard::Core::Model
            #

            @__store = {
                '52a39f11-1e65-46bb-a623-eb14f21204ba' => OperationConfig.new("/mock_crud_server/users/{user_id}/post/{post_id}", "list", [], []),
                'ed3a962a-d8b0-45cb-9f67-14537996a74b' => OperationConfig.new("/mock_crud_server/users/{user_id}/post/{post_id}", "update", [], ["testQuery"]),
                '8ee01ab0-928d-41c9-8b6d-8cd045cf69b9' => OperationConfig.new("/mock_crud_server/users/{user_id}/post/{post_id}", "delete", [], []),

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
                #List objects of type MultiplePathUserPost
                #
                #@param Dict criteria
                #@return Array of MultiplePathUserPost object matching the criteria.

                if criteria.nil?
                    return self.execute("52a39f11-1e65-46bb-a623-eb14f21204ba",MultiplePathUserPost.new)
                else
                    return self.execute("52a39f11-1e65-46bb-a623-eb14f21204ba",MultiplePathUserPost.new(criteria))
                end
            end






            def update
                #
                #Updates an object of type MultiplePathUserPost
                #
                #@return MultiplePathUserPost object representing the response.
                #
                return self.class.execute("ed3a962a-d8b0-45cb-9f67-14537996a74b",self)
            end










            def self.deleteById(id, map = nil)
                #Delete object of type MultiplePathUserPost by id

                #@param str id
                #@param Dict map, containing additional parameters
                #@return MultiplePathUserPost of the response of the deleted instance.
                
              
              
                mapObj = MultiplePathUserPost.new
                if !(id.nil? || id.empty?)
                  mapObj.set("id", id)
                end
                if !map.nil?
                    if map.instance_of? RequestMap
                      mapObj.setAll(map.getObject())
                    else
                      mapObj.setAll(map)
                    end
                end
                  
                return self.execute("8ee01ab0-928d-41c9-8b6d-8cd045cf69b9", mapObj)
            end


            def delete
                #
                #Delete object of type MultiplePathUserPost

                #@param str id
                #@return MultiplePathUserPost of the response of the deleted instance.
                #
                return self.class.execute("8ee01ab0-928d-41c9-8b6d-8cd045cf69b9", self)
            end
        end
    end
end







