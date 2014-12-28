-- Prepended SQL commands --
CREATE EXTENSION postgis;
---

-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.8.0-beta
-- PostgreSQL version: 9.1
-- Project Site: pgmodeler.com.br
-- Model Author: ---


-- Database creation must be done outside an multicommand file.
-- These commands were put in this file only for convenience.
-- -- object: "svModule" | type: DATABASE --
-- -- DROP DATABASE IF EXISTS "svModule";
-- CREATE DATABASE "svModule"
-- ;
-- -- ddl-end --
-- 

-- object: public."TUSER" | type: TABLE --
-- DROP TABLE IF EXISTS public."TUSER";
CREATE TABLE public."TUSER"(
	userid bigserial NOT NULL,
	email varchar(200),
	name varchar(200),
	pwdhash varchar(200),
	verified bit,
	creation_date date,
	CONSTRAINT "TUSER_PK" PRIMARY KEY (userid)

);
-- ddl-end --
ALTER TABLE public."TUSER" OWNER TO postgres;
-- ddl-end --

-- object: public."MYDEVICE" | type: TABLE --
-- DROP TABLE IF EXISTS public."MYDEVICE";
CREATE TABLE public."MYDEVICE"(

);
-- ddl-end --

-- object: deviceid | type: COLUMN --
-- ALTER TABLE public."MYDEVICE" DROP COLUMN IF EXISTS deviceid;
ALTER TABLE public."MYDEVICE" ADD COLUMN deviceid uuid NOT NULL;
-- ddl-end --

-- object: model | type: COLUMN --
-- ALTER TABLE public."MYDEVICE" DROP COLUMN IF EXISTS model;
ALTER TABLE public."MYDEVICE" ADD COLUMN model varchar(100);
-- ddl-end --

-- object: cordova | type: COLUMN --
-- ALTER TABLE public."MYDEVICE" DROP COLUMN IF EXISTS cordova;
ALTER TABLE public."MYDEVICE" ADD COLUMN cordova varchar(100);
-- ddl-end --

-- object: platform | type: COLUMN --
-- ALTER TABLE public."MYDEVICE" DROP COLUMN IF EXISTS platform;
ALTER TABLE public."MYDEVICE" ADD COLUMN platform varchar(100);
-- ddl-end --

-- object: version | type: COLUMN --
-- ALTER TABLE public."MYDEVICE" DROP COLUMN IF EXISTS version;
ALTER TABLE public."MYDEVICE" ADD COLUMN version varchar(100);
-- ddl-end --

-- object: name | type: COLUMN --
-- ALTER TABLE public."MYDEVICE" DROP COLUMN IF EXISTS name;
ALTER TABLE public."MYDEVICE" ADD COLUMN name varchar(100);
-- ddl-end --

-- object: userid | type: COLUMN --
-- ALTER TABLE public."MYDEVICE" DROP COLUMN IF EXISTS userid;
ALTER TABLE public."MYDEVICE" ADD COLUMN userid bigint;
-- ddl-end --

-- object: current | type: COLUMN --
-- ALTER TABLE public."MYDEVICE" DROP COLUMN IF EXISTS current;
ALTER TABLE public."MYDEVICE" ADD COLUMN current bit;
-- ddl-end --

-- object: creation_date | type: COLUMN --
-- ALTER TABLE public."MYDEVICE" DROP COLUMN IF EXISTS creation_date;
ALTER TABLE public."MYDEVICE" ADD COLUMN creation_date date;
-- ddl-end --
-- object: "PK_MYDEVICE" | type: CONSTRAINT --
-- ALTER TABLE public."MYDEVICE" DROP CONSTRAINT IF EXISTS "PK_MYDEVICE";
ALTER TABLE public."MYDEVICE" ADD CONSTRAINT "PK_MYDEVICE" PRIMARY KEY (deviceid);
-- ddl-end --

COMMENT ON COLUMN public."MYDEVICE".deviceid IS 'COMES FROM DEVICE ALREADY';
-- ddl-end --
ALTER TABLE public."MYDEVICE" OWNER TO postgres;
-- ddl-end --

-- object: public."RESOURCE" | type: TABLE --
-- DROP TABLE IF EXISTS public."RESOURCE";
CREATE TABLE public."RESOURCE"(

);
-- ddl-end --

-- object: resourceid | type: COLUMN --
-- ALTER TABLE public."RESOURCE" DROP COLUMN IF EXISTS resourceid;
ALTER TABLE public."RESOURCE" ADD COLUMN resourceid uuid NOT NULL;
-- ddl-end --

-- object: type | type: COLUMN --
-- ALTER TABLE public."RESOURCE" DROP COLUMN IF EXISTS type;
ALTER TABLE public."RESOURCE" ADD COLUMN type varchar(50) NOT NULL;
-- ddl-end --

-- object: filepath | type: COLUMN --
-- ALTER TABLE public."RESOURCE" DROP COLUMN IF EXISTS filepath;
ALTER TABLE public."RESOURCE" ADD COLUMN filepath text NOT NULL;
-- ddl-end --

-- object: creationdate | type: COLUMN --
-- ALTER TABLE public."RESOURCE" DROP COLUMN IF EXISTS creationdate;
ALTER TABLE public."RESOURCE" ADD COLUMN creationdate date;
-- ddl-end --

-- object: deviceid | type: COLUMN --
-- ALTER TABLE public."RESOURCE" DROP COLUMN IF EXISTS deviceid;
ALTER TABLE public."RESOURCE" ADD COLUMN deviceid uuid NOT NULL;
-- ddl-end --

-- object: geom | type: COLUMN --
-- ALTER TABLE public."RESOURCE" DROP COLUMN IF EXISTS geom;
ALTER TABLE public."RESOURCE" ADD COLUMN geom geometry(POINT, 4326) NOT NULL;
-- ddl-end --
-- object: "RESOURCE_PK" | type: CONSTRAINT --
-- ALTER TABLE public."RESOURCE" DROP CONSTRAINT IF EXISTS "RESOURCE_PK";
ALTER TABLE public."RESOURCE" ADD CONSTRAINT "RESOURCE_PK" PRIMARY KEY (resourceid);
-- ddl-end --

ALTER TABLE public."RESOURCE" OWNER TO postgres;
-- ddl-end --

-- object: idxtype | type: INDEX --
-- DROP INDEX IF EXISTS public.idxtype;
CREATE INDEX idxtype ON public."RESOURCE"
	USING btree
	(
	  type ASC NULLS LAST
	);
-- ddl-end --

-- object: public."ATTRIBUTES" | type: TABLE --
-- DROP TABLE IF EXISTS public."ATTRIBUTES";
CREATE TABLE public."ATTRIBUTES"(

);
-- ddl-end --

-- object: attributeid | type: COLUMN --
-- ALTER TABLE public."ATTRIBUTES" DROP COLUMN IF EXISTS attributeid;
ALTER TABLE public."ATTRIBUTES" ADD COLUMN attributeid serial NOT NULL;
-- ddl-end --

-- object: label | type: COLUMN --
-- ALTER TABLE public."ATTRIBUTES" DROP COLUMN IF EXISTS label;
ALTER TABLE public."ATTRIBUTES" ADD COLUMN label varchar(300);
-- ddl-end --

-- object: value | type: COLUMN --
-- ALTER TABLE public."ATTRIBUTES" DROP COLUMN IF EXISTS value;
ALTER TABLE public."ATTRIBUTES" ADD COLUMN value text;
-- ddl-end --

-- object: datatype | type: COLUMN --
-- ALTER TABLE public."ATTRIBUTES" DROP COLUMN IF EXISTS datatype;
ALTER TABLE public."ATTRIBUTES" ADD COLUMN datatype varchar(100);
-- ddl-end --

-- object: resourceid | type: COLUMN --
-- ALTER TABLE public."ATTRIBUTES" DROP COLUMN IF EXISTS resourceid;
ALTER TABLE public."ATTRIBUTES" ADD COLUMN resourceid uuid;
-- ddl-end --
-- object: "PK_ATTRIBUTE" | type: CONSTRAINT --
-- ALTER TABLE public."ATTRIBUTES" DROP CONSTRAINT IF EXISTS "PK_ATTRIBUTE";
ALTER TABLE public."ATTRIBUTES" ADD CONSTRAINT "PK_ATTRIBUTE" PRIMARY KEY (attributeid);
-- ddl-end --

ALTER TABLE public."ATTRIBUTES" OWNER TO postgres;
-- ddl-end --

-- object: "GIST_GEOM" | type: INDEX --
-- DROP INDEX IF EXISTS public."GIST_GEOM";
CREATE INDEX "GIST_GEOM" ON public."RESOURCE"
	USING gist
	(
	  geom
	);
-- ddl-end --

-- object: "FK_MYDEVICE_USER" | type: CONSTRAINT --
-- ALTER TABLE public."MYDEVICE" DROP CONSTRAINT IF EXISTS "FK_MYDEVICE_USER";
ALTER TABLE public."MYDEVICE" ADD CONSTRAINT "FK_MYDEVICE_USER" FOREIGN KEY (userid)
REFERENCES public."TUSER" (userid) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: "FK_RESOURCE_DEVICE" | type: CONSTRAINT --
-- ALTER TABLE public."RESOURCE" DROP CONSTRAINT IF EXISTS "FK_RESOURCE_DEVICE";
ALTER TABLE public."RESOURCE" ADD CONSTRAINT "FK_RESOURCE_DEVICE" FOREIGN KEY (deviceid)
REFERENCES public."MYDEVICE" (deviceid) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: "FK_ATTRIBUTE_RESOURCE" | type: CONSTRAINT --
-- ALTER TABLE public."ATTRIBUTES" DROP CONSTRAINT IF EXISTS "FK_ATTRIBUTE_RESOURCE";
ALTER TABLE public."ATTRIBUTES" ADD CONSTRAINT "FK_ATTRIBUTE_RESOURCE" FOREIGN KEY (resourceid)
REFERENCES public."RESOURCE" (resourceid) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


