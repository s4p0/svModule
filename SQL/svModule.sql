-- Prepended SQL commands --
CREATE EXTENSION postgis;
---

-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.8.0-beta
-- PostgreSQL version: 9.4
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
	userid integer NOT NULL,
	email varchar(200) NOT NULL,
	name varchar(200) NOT NULL,
	pwdhash varchar(200),
	verified boolean NOT NULL DEFAULT False,
	creation_date timestamp with time zone,
	CONSTRAINT "TUSER_PK" PRIMARY KEY (userid),
	CONSTRAINT "UQ_EMAIL" UNIQUE (email)

);
-- ddl-end --
ALTER TABLE public."TUSER" OWNER TO postgres;
-- ddl-end --

-- object: public."DEVICE" | type: TABLE --
-- DROP TABLE IF EXISTS public."DEVICE";
CREATE TABLE public."DEVICE"(
	deviceid integer NOT NULL,
	userid integer,
	device_uuid uuid,
	model varchar(100),
	cordova varchar(100),
	platform varchar(100),
	version varchar(100),
	name varchar(100),
	current bit,
	creation_date date,
	CONSTRAINT "PK_MYDEVICE" PRIMARY KEY (deviceid)

);
-- ddl-end --
COMMENT ON COLUMN public."DEVICE".device_uuid IS 'COMES FROM DEVICE ALREADY';
-- ddl-end --
ALTER TABLE public."DEVICE" OWNER TO postgres;
-- ddl-end --

-- object: public."RESOURCE" | type: TABLE --
-- DROP TABLE IF EXISTS public."RESOURCE";
CREATE TABLE public."RESOURCE"(
	resourceid integer NOT NULL,
	type varchar(50) NOT NULL,
	filepath text NOT NULL,
	creation_date timestamp with time zone,
	deviceid integer NOT NULL,
	geom geometry(POINT, 4326) NOT NULL,
	CONSTRAINT "RESOURCE_PK" PRIMARY KEY (resourceid)

);
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
	attributeid integer NOT NULL,
	label varchar(300),
	value text,
	datatype varchar(100),
	resourceid integer,
	CONSTRAINT "PK_ATTRIBUTE" PRIMARY KEY (attributeid)

);
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

-- object: "FK_DEVICE_USER" | type: CONSTRAINT --
-- ALTER TABLE public."DEVICE" DROP CONSTRAINT IF EXISTS "FK_DEVICE_USER";
ALTER TABLE public."DEVICE" ADD CONSTRAINT "FK_DEVICE_USER" FOREIGN KEY (userid)
REFERENCES public."TUSER" (userid) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: "FK_RESOURCE_DEVICE" | type: CONSTRAINT --
-- ALTER TABLE public."RESOURCE" DROP CONSTRAINT IF EXISTS "FK_RESOURCE_DEVICE";
ALTER TABLE public."RESOURCE" ADD CONSTRAINT "FK_RESOURCE_DEVICE" FOREIGN KEY (deviceid)
REFERENCES public."DEVICE" (deviceid) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: "FK_ATTRIBUTE_RESOURCE" | type: CONSTRAINT --
-- ALTER TABLE public."ATTRIBUTES" DROP CONSTRAINT IF EXISTS "FK_ATTRIBUTE_RESOURCE";
ALTER TABLE public."ATTRIBUTES" ADD CONSTRAINT "FK_ATTRIBUTE_RESOURCE" FOREIGN KEY (resourceid)
REFERENCES public."RESOURCE" (resourceid) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


