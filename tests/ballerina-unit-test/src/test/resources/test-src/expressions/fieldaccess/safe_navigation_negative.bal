type Person record {
    int a = 0;
    string fname = "John";
    string lname = "";
    Info|error info1?;
    Info|() info2 = ();
};

type Info record {
    Address|error address1;
    Address|() address2 = ();
};

type Address record {
    string street = "";
    string city = "";
    string country = "Sri Lanka";
};

function testErrorLiftingAcessWithoutErrorOnLHS () returns any {
    Address adrs = {city:"Colombo"};
    Info inf = {address1 : adrs};
    Person prsn = {info1 : inf};
    Person|error p = prsn;
    string|() x = p!info1!address1!city;
    return x;
}

function testFieldAcessWithoutErrorLifting () returns any|error {
    error e = error("custom error");
    Info inf = {address1 : e};
    Person prsn = {info1 : inf};
    Person|error p = prsn;
    string|error|() x = p!info1.address1!city;
    return x;
}

function testErrorLiftingOnRHS() {
    Person|error p;
    p!info1!address1!city = "Colombo";
}

function testErrorLiftingOnArray() returns Person|error {
    Person?[]|error p = error(" ");
    return p[0];
}

function testSafeNavigateOnErrorOrNull_1() returns string{
    error|() e = ();
    return e!message;
}

function testSafeNavigateOnErrorOrNull_3() returns string {
    error e = error("");
    return e!message;
}

type Student record {
    json info = {};
};

function testFunctionCallOnJSONInRecord() {
    Student? st = {};
    string s = st.info.toString();
}

function testSafeNavigateOnXMLAttachedFunctions(xml x) {
    _ = x!getTextValue();
}

function testSafeNavigateOnJSONAttachedFunctions(json j) {
    _ = j!toString();
}

function getValue() returns json|string {
    return 10;
}

function testRedundatSafeNavigate(xml x) {
    _ = getValue()!toString();
}

function getJsonValue() returns json {
    return 10;
}

function testFieldAccess() returns json|error {
    return getJsonValue()!foo;
}

function testSafeNavigationOnIndexBasedAccess() returns json|error {
    json[] data = [getJsonValue()];
    return data[0]!foo;
}
