go
create database UNIVER
on primary
(name=N'UNIVER_mdf', filename=N'C:\BD\UNIVER.mdf',
size=5120Kb, maxsize=10240Kb, filegrowth=1024Kb),
(name=N'UNIVER_ndf', filename=N'C:\BD\UNIVER.ndf',
size=5120Kb, maxsize=10240Kb, filegrowth=10%),

filegroup G1
(name=N'UNIVER1_ndf', filename=N'C:\BD\UNIVER1.ndf',
size=10240Kb, maxsize=15360Kb, filegrowth=1024Kb),
(name=N'UNIVER12_ndf', filename=N'C:\BD\UNIVER12.ndf',
size=2048Kb, maxsize=5120Kb, filegrowth=1024Kb),

filegroup G2
(name=N'UNIVER2_ndf', filename=N'C:\BD\UNIVER2.ndf',
size=5120Kb, maxsize=10240Kb, filegrowth=1024Kb),
(name=N'UNIVER22_ndf', filename=N'C:\BD\UNIVER22.ndf',
size=2048Kb, maxsize=5120Kb, filegrowth=1024Kb)

log on
(name=N'UNIVER_log', filename=N'C:\BD\UNIVER.ldf',
size=5120Kb, maxsize=UNLIMITED, filegrowth=1024Kb)
go