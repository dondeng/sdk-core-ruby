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
        class Post < MasterCard::Core::Model::BaseObject
            include MasterCard::Core::Model
            #

            @__store = {
                '781a9fdf-1f1e-4a29-819b-c16e62fe67fc' => OperationConfig.new("/mock_crud_server/posts", "list", [], ["max"]),
                'a62393bd-2ed0-487c-9d3b-dc04a257a7b8' => OperationConfig.new("/mock_crud_server/posts", "create", [], []),
                'db8c28fd-de9e-49df-9c43-c6ff9afb2b8f' => OperationConfig.new("/mock_crud_server/posts/{id}", "read", [], []),
                'cf5ba7f2-1575-4576-81c6-9ea0be0ff6f3' => OperationConfig.new("/mock_crud_server/posts/{id}", "update", [], []),
                'e12683fb-b628-4ecd-bfca-6809a2690148' => OperationConfig.new("/mock_crud_server/posts/{id}", "delete", [], []),

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
                #List objects of type Post
                #
                #@param Dict criteria
                #@return Array of Post object matching the criteria.

                if criteria.nil?
                    return self.execute("781a9fdf-1f1e-4a29-819b-c16e62fe67fc",Post.new)
                else
                    return self.execute("781a9fdf-1f1e-4a29-819b-c16e62fe67fc",Post.new(criteria))
                end
            end





            def self.create(mapObj)
                #
                #Creates object of type Post
                #
                #@param Dict mapObj, containing the required parameters to create a new object
                #@return Post of the response of created instance.
                #
                return self.execute("a62393bd-2ed0-487c-9d3b-dc04a257a7b8", Post.new(mapObj))
            end













            def self.read(id, criteria = nil)
                #
                #Returns objects of type Post by id and optional criteria
                #@param str id
                #@param dict criteria
                #@return instance of Post

                mapObj = Post.new
                mapObj.set("id", id)
                if !criteria.nil?
                    mapObj.setAll(criteria)
                end

                return self.execute("db8c28fd-de9e-49df-9c43-c6ff9afb2b8f",Post.new(mapObj))
            end




            def update
                #
                #Updates an object of type Post
                #
                #@return Post object representing the response.
                #
                return self.class.execute("cf5ba7f2-1575-4576-81c6-9ea0be0ff6f3",self)
            end










            def self.deleteById(id, map = nil)
                #Delete object of type Post by id

                #@param str id
                #@param Dict map, containing additional parameters
                #@return Post of the response of the deleted instance.

                mapObj = Post.new
                mapObj.set("id", id)
                if !map.nil?
                    mapObj.setAll(map)
                end

                return self.execute("e12683fb-b628-4ecd-bfca-6809a2690148", mapObj)
            end


            def delete
                #
                #Delete object of type Post

                #@param str id
                #@return Post of the response of the deleted instance.
                #
                return self.class.execute("e12683fb-b628-4ecd-bfca-6809a2690148", self)
            end
        end
    end
end







