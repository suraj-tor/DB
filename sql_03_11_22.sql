use assetmgt;

CREATE TABLE
    filters (
        fieldID int not null AUTO_INCREMENT,
        fileds varchar(255) not null,
        filter_name varchar(255) not null,
        PRIMARY KEY(fieldId)
    );

desc filters;

SELECT * from filters;

INSERT INTO
    filters (fileds, filter_name)
VALUES ("category", "Laptop"), ("category", "Mobile"), ("category", "Mouse"), ("category", "HDMI Cable"), ("category", "Monitor"), ("category", "Keyboard"), ("category", "Headset"), ("category", "Other"), ("screen_type", "LCD"), ("screen_type", "LED"), ("screen_type", "CCFL"), ("screen_type", "IPS-LED"), ("screen_type", "OLED"), ("screen_type", "AMOLDED"), ("screen_type", "Other"), ("ram", "4"), ("ram", "8"), ("ram", "12"), ("ram", "16"), ("ram", "32"), ("ram", "Other"), ("os", "Windows"), ("os", "Mac OS"), ("os", "Chrome OS"), ("os", "Android OS"), ("os", "Symbian"), ("os", "Other"), ("processor", "Apple M1"), ("processor", "Apple M2"), ("processor", "AMD A4"), ("processor", "AMD A8"), ("processor", "AMD Ryzen 3"), ("processor", "AMD Ryzen 5"), ("processor", "AMD Ryzen 7"), ("processor", "AMD Ryzen 9"), ("processor", "Intel Celeron"), ("processor", "Intel Core 2"), ("processor", "Intel Core i3"), ("processor", "Intel Core i5"), ("processor", "Intel Core i7"), ("processor", "Intel Core i9"), ("processor", "Intel Pentium"), ("processor", "Other"), ("screen_size", "11 inches"), ("screen_size", "13 inches"), ("screen_size", "15 inches"), ("screen_size", "17 inches"), ("screen_size", "Other"), (
        "asset_location",
        "Toronto, Canada"
    ), (
        "asset_location",
        "Pune, India"
    ), (
        "asset_location",
        "Nagpur, India"
    ), ("asset_location", "Other"), ("status", "Surplus"), ("status", "Allocated"), ("status", "Broken"), ("status", "repairable");

--------create table for tracking the transaction of assets
