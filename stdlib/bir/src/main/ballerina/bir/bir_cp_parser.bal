// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

public type ConstPool record {
    ModuleID[] packages = [];
    string[] strings = [];
    int[] ints = [];
    float[] floats = [];
};

public type ConstPoolParser object {
    ChannelReader reader;
    ConstPool cp = {};
    int i;

    public function __init(ChannelReader reader) {
        self.reader = reader;
        self.i = 0;
    }

    public function parse() returns ConstPool {
        var cpCount = self.reader.readInt32();
        while (self.i < cpCount) {
            self.parseConstPoolEntry();
            self.i += 1;
        }
        return self.cp;
    }

    public function parseConstPoolEntry() {
        var cpType = self.reader.readInt8();

        if (cpType == 1){
            self.parseInt();
        } else if (cpType == 2){
            self.parseFloat();
        } else if (cpType == 4){
            self.parseString();
        } else if (cpType == 5){
            self.parseModuleID();
        } else {
            error err = error("cp type " + cpType + " not supported.:");
            panic err;
        }
    }

    function parseInt() {
        self.cp.ints[self.i] = self.reader.readInt64();
    }

    function parseFloat() {
        self.cp.floats[self.i] = self.reader.readFloat64();
    }

    function parseString() {
        self.cp.strings[self.i] = self.reader.readString();
    }

    function parseModuleID() {
        ModuleID id = { org: self.cp.strings[self.reader.readInt32()],
            name: self.cp.strings[self.reader.readInt32()],
            modVersion: self.cp.strings[self.reader.readInt32()] };
        self.cp.packages[self.i] = id;
    }

};

