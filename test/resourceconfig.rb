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

require "mastercard/core/constants"
require "mastercard/core/config"


class ResourceConfig
    include MasterCard::Core

    @@instance = nil

    def initialize
        @name = "someRandomName"
        @override = nil
        @host = nil
        @context = nil
        @version = "0.0.1"

        Config.registerResourceConfig(self)
        currentEnvironment = Config.getEnvironment()
        self.setEnvironment(currentEnvironment)

    end


    def self.instance
        return @@instance
    end


    def getName
        return @name
    end


    def getHost
        unless @override.nil? || @override == 0
            return @@override
        else
            return @host
        end
    end

    def getContext
        return @context
    end

    def getVersion
        return @version
    end

    def setEnvironment(environmet)
        if Environment::MAPPING.key?(environmet)
            tuple = Environment::MAPPING[environmet]
            @host = tuple[0]
            @context = tuple[1]
        end
    end

    @@instance = ResourceConfig.new

    private_class_method :new
end








