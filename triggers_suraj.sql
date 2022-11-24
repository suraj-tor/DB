CREATE TRIGGER `AFTER_ADDING_STORAGE` AFTER UPDATE 
ON `ASSETS` 
	FOR EACH ROW begin IF (
	    old.HDD IS NULL
	    and new.HDD
	) THEN
	INSERT INTO
	    transaction_log (
	        event_name,
	        asset_id,
	        update_feature,
	        update_description,
	        date
	    )
	VALUES (
	        'Asset Update',
	        new.assetId, (
	            SELECT
	                COLUMN_NAME
	            FROM
	                INFORMATION_SCHEMA.COLUMNS
	            WHERE
	                TABLE_SCHEMA = 'assetmgt'
	                AND TABLE_NAME = 'assets'
	                AND COLUMN_NAME = 'HDD'
	        ), (
	            concat('Added new ', new.HDD, 'gb')
	        ),
	        now()
	    );
	
	ELSEIF (
	    old.SSD IS NULL
	    AND new.SSD
	) THEN
	INSERT INTO
	    transaction_log (
	        event_name,
	        asset_id,
	        update_feature,
	        update_description,
	        date
	    )
	VALUES (
	        'Asset Update',
	        new.assetId, (
	            SELECT
	                COLUMN_NAME
	            FROM
	                INFORMATION_SCHEMA.COLUMNS
	            WHERE
	                TABLE_SCHEMA = 'assetmgt'
	                AND TABLE_NAME = 'assets'
	                AND COLUMN_NAME = 'SSD'
	        ), (
	            concat('Added new ', new.SSD, 'gb')
	        ),
	        now()
	    );
	
	END IF;
END; 

CREATE TRIGGER `AFTER_ASSET_ALLOCATION` AFTER INSERT 
ON `ASSETALLOCATION` 
	FOR EACH ROW BEGIN
	INSERT INTO
	    transaction_log (
	        event_name,
	        asset_id,
	        emp_id,
	        emp_name,
	        asset_status,
	        date
	    )
	VALUES (
	        'Asset Allocation',
	        new.assetId, (new.empId), (
	            SELECT name
	            from employees
	            where
	                empId = new.empId
	        ),
	        'allocated',
	        now()
	    );
END; 

CREATE TRIGGER `AFTER_ASSET_CREATION` AFTER INSERT 
ON `ASSETS` 
	FOR EACH ROW BEGIN
	INSERT INTO
	    transaction_log (
	        event_name,
	        asset_id,
	        asset_status,
	        date
	    )
	VALUES (
	        'Asset Received',
	        new.assetId,
	        'surplus',
	        now()
	    );
END; 

CREATE TRIGGER `AFTER_ASSET_DEALLOCATION` AFTER DELETE 
ON `ASSETALLOCATION` 
	FOR EACH ROW BEGIN
	INSERT INTO
	    transaction_log (
	        event_name,
	        asset_id,
	        emp_id,
	        emp_name,
	        asset_status,
	        date
	    )
	VALUES (
	        'Asset Deallocation',
	        old.assetId, (old.empId), (
	            SELECT name
	            from employees
	            where
	                empId = old.empId
	        ),
	        'surplus',
	        now()
	    );
END; 

CREATE TRIGGER `AFTER_ASSET_STATUS_CHANGED` AFTER UPDATE 
ON `ASSETS` 
	FOR EACH ROW BEGIN IF (
	    old.status <> 'allocated'
	    AND new.status <> 'allocated'
	    AND old.status <> new.status
	) THEN
	INSERT INTO
	    transaction_log (
	        event_name,
	        asset_id,
	        asset_status,
	        date
	    )
	VALUES (
	        'Asset status changed',
	        new.assetId,
	        concat(old.status, ' to ', new.status),
	        now()
	    );
	
	END IF;
END; 

CREATE TRIGGER `AFTER_ASSET_UPDATE` AFTER UPDATE ON 
`ASSETS` 
	FOR EACH ROW BEGIN IF (new.ram <> old.ram) THEN
	INSERT INTO
	    transaction_log (
	        event_name,
	        asset_id,
	        update_feature,
	        update_description,
	        asset_status,
	        date
	    )
	VALUES (
	        'Asset Update',
	        new.assetId, (
	            SELECT
	                COLUMN_NAME
	            FROM
	                INFORMATION_SCHEMA.COLUMNS
	            WHERE
	                TABLE_SCHEMA = 'assetmgt'
	                AND TABLE_NAME = 'assets'
	                AND COLUMN_NAME = 'ram'
	        ), (
	            concat(
	                'from ',
	                old.ram,
	                'gb',
	                ' to ',
	                new.ram,
	                'gb'
	            )
	        ), (
	            select status
	            from assets
	            where
	                assetId = new.assetId
	        ),
	        now()
	    );
	
	ELSEIF (
	    new.operating_system <> old.operating_system
	) THEN
	INSERT INTO
	    transaction_log (
	        event_name,
	        asset_id,
	        update_feature,
	        update_description,
	        asset_status,
	        date
	    )
	VALUES (
	        'Asset Update',
	        new.assetId, (
	            SELECT
	                COLUMN_NAME
	            FROM
	                INFORMATION_SCHEMA.COLUMNS
	            WHERE
	                TABLE_SCHEMA = 'assetmgt'
	                AND TABLE_NAME = 'assets'
	                AND COLUMN_NAME = 'operating_system'
	        ), (
	            concat(
	                'from ',
	                old.operating_system,
	                ' to ',
	                new.operating_system
	            )
	        ), (
	            select status
	            from assets
	            where
	                assetId = new.assetId
	        ),
	        now()
	    );
	
	ELSEIF (new.HDD <> old.HDD) THEN
	INSERT INTO
	    transaction_log (
	        event_name,
	        asset_id,
	        update_feature,
	        update_description,
	        asset_status,
	        date
	    )
	VALUES (
	        'Asset Update',
	        new.assetId, (
	            SELECT
	                COLUMN_NAME
	            FROM
	                INFORMATION_SCHEMA.COLUMNS
	            WHERE
	                TABLE_SCHEMA = 'assetmgt'
	                AND TABLE_NAME = 'assets'
	                AND COLUMN_NAME = 'HDD'
	        ), (
	            concat(
	                'from ',
	                old.HDD,
	                'gb',
	                ' to ',
	                new.HDD,
	                'gb'
	            )
	        ), (
	            select status
	            from assets
	            where
	                assetId = new.assetId
	        ),
	        now()
	    );
	
	ELSEIF (new.SSD <> old.SSD) THEN
	INSERT INTO
	    transaction_log (
	        event_name,
	        asset_id,
	        update_feature,
	        update_description,
	        asset_status,
	        date
	    )
	VALUES (
	        'Asset Update',
	        new.assetId, (
	            SELECT
	                COLUMN_NAME
	            FROM
	                INFORMATION_SCHEMA.COLUMNS
	            WHERE
	                TABLE_SCHEMA = 'assetmgt'
	                AND TABLE_NAME = 'assets'
	                AND COLUMN_NAME = 'SSD'
	        ), (
	            concat(
	                'from ',
	                old.SSD,
	                'gb',
	                ' to ',
	                new.SSD,
	                'gb'
	            )
	        ), (
	            select status
	            from assets
	            where
	                assetId = new.assetId
	        ),
	        now()
	    );
	
	END IF;
END; 

CREATE TRIGGER `AFTER_REMOVE_STORAGE` AFTER UPDATE 
ON `ASSETS` 
	FOR EACH ROW begin IF (
	    new.HDD IS NULL
	    AND old.HDD
	) THEN
	INSERT INTO
	    transaction_log (
	        event_name,
	        asset_id,
	        update_feature,
	        update_description,
	        date
	    )
	VALUES (
	        'Asset Update',
	        new.assetId, (
	            SELECT
	                COLUMN_NAME
	            FROM
	                INFORMATION_SCHEMA.COLUMNS
	            WHERE
	                TABLE_SCHEMA = 'assetmgt'
	                AND TABLE_NAME = 'assets'
	                AND COLUMN_NAME = 'HDD'
	        ), (
	            concat('Removed ', old.HDD, 'gb')
	        ),
	        now()
	    );
	
	ELSEIF (
	    new.SSD IS NULL
	    AND old.SSD
	) THEN
	INSERT INTO
	    transaction_log (
	        event_name,
	        asset_id,
	        update_feature,
	        update_description,
	        date
	    )
	VALUES (
	        'Asset Update',
	        new.assetId, (
	            SELECT
	                COLUMN_NAME
	            FROM
	                INFORMATION_SCHEMA.COLUMNS
	            WHERE
	                TABLE_SCHEMA = 'assetmgt'
	                AND TABLE_NAME = 'assets'
	                AND COLUMN_NAME = 'SSD'
	        ), (
	            concat('Removed ', old.SSD, 'gb')
	        ),
	        now()
	    );
	
	END IF;
END; 

CREATE TRIGGER `AFTER_TICKET_RAISED` AFTER INSERT ON 
`TICKETS` FOR EACH ROW BEGIN 
	INSERT INTO
	    transaction_log (
	        event_name,
	        asset_id,
	        ticket_id,
	        emp_id,
	        emp_name,
	        date
	    )
	VALUES (
	        'Ticket raised',
	        new.assetId, (new.ticketID), (new.empId), (
	            select name
	            from employees
	            where
	                empId = new.empId
	        ),
	        now()
	    );
END; 

CREATE TRIGGER `AFTER_TICKET_RAISED` AFTER INSERT ON 
`TICKETS` FOR EACH ROW BEGIN 
	INSERT INTO
	    transaction_log (
	        event_name,
	        asset_id,
	        ticket_id,
	        emp_id,
	        emp_name,
	        date
	    )
	VALUES (
	        'Ticket raised',
	        new.assetId, (new.ticketID), (new.empId), (
	            select name
	            from employees
	            where
	                empId = new.empId
	        ),
	        now()
	    );
END; 

CREATE TRIGGER `BEFORE_ASSET_DELETE` BEFORE UPDATE 
ON `ASSETS` 
	FOR EACH ROW BEGIN IF (new.is_active = 0) THEN
	INSERT INTO
	    transaction_log (
	        event_name,
	        asset_id,
	        asset_status,
	        date
	    )
	VALUES (
	        'Asset Deleted',
	        old.assetId,
	        'broken',
	        now()
	    );
	
	END IF;
END; 