CREATE Table
    transaction_log (
        log_id INT NOT NULL AUTO_INCREMENT,
        event_name VARCHAR(100) NOT null,
        asset_id INT NOT NULL,
        ticket_id INT DEFAULT null,
        emp_id VARCHAR(100) DEFAULT null,
        emp_name VARCHAR(100) DEFAULT null,
        asset_status VARCHAR(100) DEFAULT null,
        update_feature VARCHAR(100) DEFAULT null,
        update_description VARCHAR(100) DEFAULT null,
        date DATETIME not null,
        PRIMARY KEY(log_id),
        Foreign Key (asset_id) REFERENCES assets(assetId),
        Foreign Key (emp_id) REFERENCES employees(empId),
        Foreign Key (ticket_id) REFERENCES tickets(ticketId)
    );

-- DROP TRIGGER AFTER_ASSET_CREATION;

CREATE TRIGGER AFTER_ASSET_CREATION AFTER INSERT 
ON ASSETS 
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

-- DROP TRIGGER AFTER_ASSET_ALLOCATION;

CREATE TRIGGER AFTER_ASSET_ALLOCATION AFTER INSERT 
ON ASSETALLOCATION 
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

-- DROP TRIGGER AFTER_TICKET_RAISED;

CREATE TRIGGER AFTER_TICKET_RAISED AFTER INSERT ON 
TICKETS FOR EACH ROW BEGIN 
	INSERT INTO
	    transaction_log (
	        event_name,
	        asset_id,
	        ticket_id,
	        emp_id,
	        date
	    )
	VALUES (
	        'Ticket raised',
	        new.assetId, (new.ticketID), (new.empId),
	        now()
	    );
END; 

-- DROP TRIGGER AFTER_TICKET_SOLVED;

CREATE TRIGGER AFTER_TICKET_SOLVED BEFORE UPDATE ON 
TICKETS FOR EACH ROW BEGIN 
	IF (new.ticketStatus = 'closed') THEN
	INSERT INTO
	    transaction_log (
	        event_name,
	        asset_id,
	        ticket_id,
	        emp_id,
	        date
	    )
	VALUES (
	        'Ticket solved',
	        old.assetId, (old.ticketID), (old.empId),
	        now()
	    );
	END IF;
END; 

-- DROP TRIGGER assetmgt.AFTER_ASSET_UPDATE;

CREATE TRIGGER AFTER_ASSET_UPDATE AFTER UPDATE ON ASSETS 
	FOR EACH ROW BEGIN IF (new.ram <> old.ram) THEN
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
	        ),
	        now()
	    );
	END IF;
END; 

-- DROP TRIGGER AFTER_ASSET_DEALLOCATION;

CREATE TRIGGER AFTER_ASSET_DEALLOCATION AFTER DELETE 
ON ASSETALLOCATION 
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

-- DROP TRIGGER BEFORE_ASSET_DELETE;

CREATE TRIGGER BEFORE_ASSET_DELETE BEFORE UPDATE ON ASSETS 
	FOR EACH ROW BEGIN IF (new.is_active = 0) THEN
	SET new.deleted_at = now();
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