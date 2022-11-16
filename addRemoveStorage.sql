DROP TRIGGER AFTER_ADDING_STORAGE;

CREATE TRIGGER AFTER_ADDING_STORAGE
AFTER
UPDATE
    ON assets for each row begin IF (old.HDD IS NULL and new.HDD) THEN
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
        (concat('Added new ', new.HDD,'gb')),
        now()
    );

ELSEIF (old.SSD IS NULL AND new.SSD) THEN
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
        (concat('Added new ', new.SSD,'gb')),
        now()
    );

END IF;

END;

DROP TRIGGER AFTER_REMOVE_STORAGE;

CREATE TRIGGER AFTER_REMOVE_STORAGE
AFTER
UPDATE
    ON assets for each row begin IF (new.HDD IS NULL AND old.HDD) THEN
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
        (concat('Removed ', old.HDD,'gb')),
        now()
    );

ELSEIF (new.SSD IS NULL AND old.SSD) THEN
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
        (concat('Removed ', old.SSD,'gb')),
        now()
    );

END IF;

end;

SELECT
    *
FROM
    assets
WHERE
    `category` like '%laptop%'
LIMIT
    100;