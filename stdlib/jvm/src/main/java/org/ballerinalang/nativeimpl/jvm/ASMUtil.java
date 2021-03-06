/*
 * Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package org.ballerinalang.nativeimpl.jvm;

import org.ballerinalang.bre.Context;
import org.ballerinalang.model.types.BStructureType;
import org.ballerinalang.model.values.BMap;
import org.ballerinalang.model.values.BValue;
import org.ballerinalang.util.codegen.PackageInfo;
import org.ballerinalang.util.codegen.StructureTypeInfo;
import org.ballerinalang.util.exceptions.BallerinaException;

import static org.ballerinalang.util.BLangConstants.BALLERINA_PACKAGE_PREFIX;

/**
 * A util class to handle native data get and set operations with ASM and JVM stdlib.
 *
 * @since 0.995.0
 */
public class ASMUtil {

    public static final String CLASS_WRITER = "ClassWriter";
    public static final String METHOD_VISITOR = "MethodVisitor";
    public static final String FIELD_VISITOR = "FieldVisitor";
    public static final String LABEL = "Label";
    public static final String JVM_PKG_PATH = BALLERINA_PACKAGE_PREFIX + "jvm";
    public static final String NATIVE_KEY = "native";

    public static final String OBJECT_DESC = "Ljava/lang/Object;";
    public static final String FUNCTION_DESC = "Ljava/util/function/Function;";
    public static final String STRING_DESC = "Ljava/lang/String;";
    public static final String METHOD_TYPE_DESC = "Ljava/lang/invoke/MethodType;";
    public static final String MAP_VALUE_DESC = "Lorg/ballerinalang/jvm/values/MapValue;";

    public static BMap<String, BValue> newObject(Context context, String type) {

        PackageInfo packageInfo = context.getProgramFile().getPackageInfo(JVM_PKG_PATH);
        if (packageInfo == null) {
            throw new BallerinaException("package - " + JVM_PKG_PATH + " does not exist");
        }
        StructureTypeInfo structureInfo = packageInfo.getStructInfo(type);
        BStructureType structType = structureInfo.getType();
        return new BMap<>(structType);
    }

    public static <T> T getRefArgumentNativeData(Context context, int index) {

        return getNativeData(context.getRefArgument(index));
    }

    private static <T> T getNativeData(BValue ref) {

        return (T) ((BMap<String, BValue>) ref).getNativeData(NATIVE_KEY);
    }

    public static void addNativeDataToObject(Object data, BMap<String, BValue> bStruct) {

        bStruct.addNativeData(NATIVE_KEY, data);
    }
}
