SHOW TRIGGERS IN assetmgt;

-- DROP TRIGGER assetmgt.AFTER_ALLOCATING_NEW_ASSET;

-- DROP TRIGGER assetmgt.AFTER_DEALLOCATING_ASSET;

DROP TRIGGER assetmgt.AFTER_DELETE_EMP;

SET FOREIGN_KEY_CHECKS=0;

-- to disable them

-- SET FOREIGN_KEY_CHECKS=1; -- to re-enable them

--------create table for tracking the transaction of assets

CREATE TABLE
    transaction_history (
        txn_id int not null AUTO_INCREMENT,
        asset_id int not null,
        emp_id VARCHAR(100) not null,
        start_date_value DATETIME not null,
        end_date_value DATETIME,
        status VARCHAR(255) not null,
        PRIMARY KEY(txn_id),
        Foreign Key (asset_id) REFERENCES assets(assetId),
        Foreign Key (emp_id) REFERENCES employees(empId)
    );

CREATE TRIGGER AFTER_ALLOCATING_NEW_ASSET AFTER INSERT 
ON ASSETALLOCATION 
	for each row BEGIN
	INSERT into
	    transaction_history (
	        asset_id,
	        emp_id,
	        start_date_value,
	        end_date_value,
	        status
	    )
	VALUES (
	        new.assetId,
	        new.empId,
	        now(),
	        null,
	        "allocated"
	    );
END; 

CREATE TRIGGER AFTER_DEALLOCATING_ASSET AFTER DELETE 
ON ASSETALLOCATION 
	FOR EACH ROW BEGIN
	UPDATE transaction_history
	SET
	    end_date_value = now(),
	    status = 'surplus'
	WHERE asset_id = old.assetId;
	UPDATE assets
	SET assets.status = 'surplus'
	WHERE assetId = old.assetId;
END; 

CREATE TRIGGER AFTER_DELETE_EMP AFTER DELETE ON EMPLOYEES 
FOR EACH ROW BEGIN 
	DELETE FROM assetallocation where empId = old.empId;
END; 

DELETE from employees WHERE empId='E112';

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
