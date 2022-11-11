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
VALUES
    (
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
        assetallocationId,
        empId,
        assetId,
        allocationTime
    )
VALUES
    (
        6,
        'E112',
        109,
        now()
    );

INSERT INTO
    assetallocation(
        assetallocationId,
        empId,
        assetId,
        allocationTime
    )
VALUES
    (
        7,
        'E112',
        112,
        now()
    );

UPDATE
    tickets
SET
    `ticketStatus` = 'closed'
WHERE
    `ticketId` = 33;