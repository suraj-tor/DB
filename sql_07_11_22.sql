SHOW TRIGGERS IN assetmgt;

SET
    FOREIGN_KEY_CHECKS = 0;

-- to disable them
-- SET FOREIGN_KEY_CHECKS=1; -- to re-enable them
--------create table for tracking the transaction of assets
CREATE TABLE transaction_history (
    transaction_id int not null AUTO_INCREMENT,
    asset_id int not null,
    received_date DATETIME NOT NULL,
    emp_id VARCHAR(100) DEFAULT '-',
    emp_name VARCHAR(100) DEFAULT '-',
    allocation_date DATETIME DEFAULT NULL,
    deallocation_date DATETIME DEFAULT NULL,
    status VARCHAR(100) not null,
    PRIMARY KEY(transaction_id),
    Foreign Key (asset_id) REFERENCES assets(assetId),
    Foreign Key (emp_id) REFERENCES employees(empId)
);

-- DROP TABLE IF EXISTS `asset_update`;

-- CREATE TABLE asset_update (
--     asset_update_id int not null AUTO_INCREMENT,
--     asset_id int not null,
--     updated_feature VARCHAR(100) DEFAULT NULL,
--     description VARCHAR(100) NOT NULL,
--     effective_date DATETIME NOT NULL,
--     PRIMARY KEY(asset_update_id),
--     Foreign Key (asset_id) REFERENCES assets(assetId)
-- );

-- DROP TRIGGER assetmgt.AFTER_ALLOCATING_NEW_ASSET;
CREATE TRIGGER AFTER_ALLOCATING_NEW_ASSET
AFTER
INSERT
    ON ASSETALLOCATION for each row BEGIN
INSERT into
    transaction_log (
        asset_id,
        received_date,
        emp_id,
        emp_name,
        allocation_date,
        status
    )
VALUES
    (
        new.assetId,
        (
            SELECT
                received_date
            FROM
                assets
            WHERE
                assetId = new.assetId
        ),
        new.empId,
        (
            SELECT
                name
            from
                employees
            where
                empId = new.empId
        ),
        now(),
        'allocated'
    );

END;

-- DROP TRIGGER assetmgt.AFTER_DEALLOCATING_ASSET;
CREATE TRIGGER AFTER_DEALLOCATING_ASSET
AFTER
    DELETE ON ASSETALLOCATION FOR EACH ROW BEGIN
UPDATE
    transaction_history
SET
    deallocation_date = now(),
    status = 'surplus'
WHERE
    asset_id = old.assetId;

END;

UPDATE
    assets
SET
    assets.status = 'surplus'
WHERE
    assetId = old.assetId;

-- DROP TRIGGER assetmgt.AFTER_ASSET_UPDATE;
CREATE TRIGGER AFTER_ASSET_UPDATE
AFTER
UPDATE
    ON ASSETS FOR EACH ROW BEGIN IF (new.ram <> old.ram) THEN
INSERT INTO
    asset_update (
        asset_id,
        updated_feature,
        description,
        effective_date
    )
VALUES
    (
        new.assetId,
        (
            SELECT
                COLUMN_NAME
            FROM
                INFORMATION_SCHEMA.COLUMNS
            WHERE
                TABLE_SCHEMA = 'assetmgt'
                AND TABLE_NAME = 'assets'
                AND COLUMN_NAME = 'ram'
        ),
        (
            concat(
                'from ',
                old.ram,
                ' to ',
                new.ram
            )
        ),
        now()
    );

ELSEIF (new.operating_system <> old.operating_system) THEN
INSERT INTO
    asset_update (
        asset_id,
        updated_feature,
        description,
        effective_date
    )
VALUES
    (
        new.assetId,
        (
            SELECT
                COLUMN_NAME
            FROM
                INFORMATION_SCHEMA.COLUMNS
            WHERE
                TABLE_SCHEMA = 'assetmgt'
                AND TABLE_NAME = 'assets'
                AND COLUMN_NAME = 'operating_system'
        ),
        (
            concat(
                'from ',
                old.operating_system,
                ' to ',
                new.operating_system
            )
        ),
        now()
    );

ELSEIF (new.HDD <> old.HDD) THEN
INSERT INTO
    asset_update (
        asset_id,
        updated_feature,
        description,
        effective_date
    )
VALUES
    (
        new.assetId,
        (
            SELECT
                COLUMN_NAME
            FROM
                INFORMATION_SCHEMA.COLUMNS
            WHERE
                TABLE_SCHEMA = 'assetmgt'
                AND TABLE_NAME = 'assets'
                AND COLUMN_NAME = 'HDD'
        ),
        (
            concat(
                'from ',
                old.HDD,'gb',
                ' to ',
                new.HDD,'gb'
            )
        ),
        now()
    );

ELSEIF (new.SSD <> old.SSD) THEN
INSERT INTO
    asset_update (
        asset_id,
        updated_feature,
        description,
        effective_date
    )
VALUES
    (
        new.assetId,
        (
            SELECT
                COLUMN_NAME
            FROM
                INFORMATION_SCHEMA.COLUMNS
            WHERE
                TABLE_SCHEMA = 'assetmgt'
                AND TABLE_NAME = 'assets'
                AND COLUMN_NAME = 'SSD'
        ),
        (
            concat(
                'from ',
                old.SSD,'gb',
                ' to ',
                new.SSD,'gb'
            )
        ),
        now()
    );

END IF;

END;

-- DROP TRIGGER assetmgt.BEFORE_CLOSING_TICKET;
CREATE TRIGGER BEFORE_CLOSING_TICKET BEFORE
UPDATE
    ON tickets FOR EACH ROW BEGIN IF (new.ticketStatus = 'closed') THEN
SET
    new.closedAt = now();

END IF;

END;

DROP TRIGGER assetmgt.BEFORE_DELETING_ASSET;

CREATE TRIGGER BEFORE_DELETING_ASSET BEFORE
UPDATE
    ON assets FOR EACH ROW BEGIN IF (new.is_active = 0) THEN
SET
    new.deleted_at = now();
END IF;

END;

UPDATE
    assets
SET
    is_active = 0
WHERE
    assetId = 112;