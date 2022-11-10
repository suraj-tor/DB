SHOW TRIGGERS IN assetmgt;

SET FOREIGN_KEY_CHECKS=0;

-- to disable them

-- SET FOREIGN_KEY_CHECKS=1; -- to re-enable them

--------create table for tracking the transaction of assets

CREATE TABLE
    transaction_history (
        transaction_id int not null AUTO_INCREMENT,
        asset_id int not null,
        received_date DATETIME NOT NULL,
        emp_id VARCHAR(100) not null,
        emp_name VARCHAR(100) not null,
        allocation_date DATETIME not null,
        deallocation_date DATETIME DEFAULT NULL,
        status VARCHAR(255) not null,
        ticket_id int DEFAULT NULL,
        ticket_generated_date DATETIME DEFAULT NULL,
        ticket_resolved_date DATETIME DEFAULT NULL,
        asset_updation VARCHAR(255) DEFAULT NULL,
        asset_delete VARCHAR(100) DEFAULT 0,
        PRIMARY KEY(transaction_id),
        Foreign Key (asset_id) REFERENCES assets(assetId),
        Foreign Key (emp_id) REFERENCES employees(empId)
    );

-- DROP TRIGGER assetmgt.AFTER_ALLOCATING_NEW_ASSET;

CREATE TRIGGER AFTER_ALLOCATING_NEW_ASSET AFTER INSERT 
ON ASSETALLOCATION 
	for each row BEGIN
	INSERT into
	    transaction_history (
	        asset_id,
	        received_date,
	        emp_id,
	        emp_name,
	        allocation_date,
	        status
	    )
	VALUES (
	        new.assetId, (
	            SELECT
	                received_date
	            FROM assets
	            WHERE
	                assetId = new.assetId
	        ),
	        new.empId, (
	            SELECT name
	            from employees
	            where
	                empId = new.empId
	        ),
	        now(),
	        'allocated'
	    );
END; 

-- DROP TRIGGER assetmgt.AFTER_DEALLOCATING_ASSET;

CREATE TRIGGER AFTER_DEALLOCATING_ASSET AFTER DELETE 
ON ASSETALLOCATION 
	FOR EACH ROW BEGIN
	UPDATE transaction_history
	SET
	    deallocation_date = now(),
	    status = 'surplus'
	WHERE asset_id = old.assetId;
	UPDATE assets
	SET assets.status = 'surplus'
	WHERE assetId = old.assetId;
END; 

-- DROP TRIGGER assetmgt.AFTER_DELETE_ASSET;

CREATE TRIGGER AFTER_DELETE_ASSET AFTER UPDATE ON ASSETS 
	FOR EACH ROW BEGIN IF new.is_active <> old.is_active THEN
	UPDATE transaction_history
	SET asset_delete = 1
	WHERE
	    asset_id = old.assetId;
	END IF;
END; 

INSERT INTO
    employees(
        `empId`,
        name,
        email,
        phone,
        password,
        location,
        `jobTitle`
    )
VALUES (
        'E112',
        'Suraj Mahamuni',
        'suraj.mahamuni@torinit.ca',
        9374562283,
        '123',
        'Pune',
        'Software Engineer'
    );

INSERT INTO
    assetallocation(
        `assetallocationId`,
        `empId`,
        `assetId`,
        `allocationTime`
    )
VALUES (
        6,
        'E112',
        109,
        '2022-11-08 18:00:17'
    );

INSERT INTO
    assetallocation(
        `assetallocationId`,
        `empId`,
        `assetId`,
        `allocationTime`
    )
VALUES (
        7,
        'E112',
        112,
        '2022-11-08 18:00:17'
    );