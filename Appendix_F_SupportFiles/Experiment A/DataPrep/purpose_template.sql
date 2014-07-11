--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = arc_tbw, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: households; Type: TABLE; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

CREATE TABLE households (
    sampno integer NOT NULL,
    lang character varying(5),
    hhsize integer,
    hhveh integer,
    traveldate timestamp without time zone,
    assn integer,
    iswritable integer DEFAULT 1 NOT NULL,
    tbtraveldate timestamp without time zone
);


ALTER TABLE arc_tbw.households OWNER TO postgres;

--
-- Name: householdsextended; Type: TABLE; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

CREATE TABLE householdsextended (
    sampno integer NOT NULL,
    pin character varying(50),
    callattempts integer DEFAULT 0 NOT NULL,
    recruit_mode integer,
    catsi integer,
    gps_pr_release integer,
    cati_release integer,
    hh_complete integer,
    incompleteperno character varying(75),
    completed integer,
    incompletepercount integer,
    gps_notes text,
    cloned integer,
    gflag integer,
    deldateid integer,
    controlcode integer,
    income integer,
    gtype integer,
    sample integer
);


ALTER TABLE arc_tbw.householdsextended OWNER TO postgres;

--
-- Name: locations; Type: TABLE; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

CREATE TABLE locations (
    sampno integer NOT NULL,
    locno integer NOT NULL,
    ptype integer,
    locname character varying(255),
    address_number character varying(15),
    address_street character varying(255),
    address_unit character varying(25),
    city character varying(255),
    postcode character varying(25),
    country character varying(125),
    xcoord double precision,
    ycoord double precision,
    xstreet character varying(255),
    neighborhood character varying(255),
    iscommon integer,
    perno integer,
    locorder integer,
    longitude double precision,
    latitude double precision,
    full_address text,
    state character varying(125),
    nearchurch integer DEFAULT 0 NOT NULL,
    nearbigbox integer DEFAULT 0 NOT NULL,
    lu_commercial integer DEFAULT 0 NOT NULL,
    lu_institutional integer DEFAULT 0 NOT NULL,
    geom public.geometry(Point,4326),
    lu_name character(15),
    lu_parks integer DEFAULT 0 NOT NULL
);


ALTER TABLE arc_tbw.locations OWNER TO postgres;

--
-- Name: personextended; Type: TABLE; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

CREATE TABLE personextended (
    sampno integer NOT NULL,
    perno integer NOT NULL,
    nogo character varying(250),
    nogowhy character varying(250),
    nogowhy_o character varying(250),
    completed integer,
    havelog integer,
    proxyperno integer,
    emply integer,
    isvisitor integer DEFAULT 0 NOT NULL,
    pytoll integer,
    pass integer,
    agency character varying(250),
    faretype character varying(250),
    pass_amt character varying(250),
    pass_sub character varying(250),
    wmode smallint,
    fwktw smallint,
    fbktw smallint,
    smode smallint,
    fwkts smallint,
    fbkts smallint,
    bikeown smallint,
    primdr smallint DEFAULT 0 NOT NULL,
    lic smallint,
    dtype smallint,
    t_asset smallint,
    volun smallint,
    prima smallint,
    jobs smallint,
    hrs1 smallint,
    hrs2 smallint,
    tchrs smallint,
    tlwkd smallint,
    wdays smallint,
    educa smallint,
    indus smallint,
    occup smallint,
    wloc smallint,
    park smallint,
    parkloc smallint,
    stude smallint,
    schol smallint,
    sloc smallint,
    sonln smallint,
    t_asset2 smallint,
    t_asset3 smallint,
    dtype_o_2 text,
    selpass character varying(2),
    selpass2 character varying(2),
    selpass3 character varying(2),
    selpass4 character varying(2),
    selpass5 character varying(2),
    selpass6 character varying(2),
    setpass smallint,
    prngp smallint,
    schol_o_2 text,
    skospass smallint,
    prn11 smallint,
    sngh2 character varying(100),
    isadult boolean,
    isold boolean,
    isyoung boolean,
    isdrivingagechild boolean,
    ispredriving boolean,
    ispreschool boolean,
    isftworker boolean,
    isptworker boolean,
    isunivstud boolean,
    isretiree boolean,
    isnonworker boolean,
    ispreschool2 boolean,
    isindeterminate boolean,
    finalpersoncategory integer,
    works integer,
    wkstat integer,
    hours integer,
    volunteer boolean,
    gender integer,
    finalftworker boolean,
    finalptworker boolean,
    finalunivstud boolean,
    finalnonworker boolean,
    finalretiree boolean,
    finaldrivingagechild boolean,
    finalpredriving boolean,
    finalpreschool boolean
);


ALTER TABLE arc_tbw.personextended OWNER TO postgres;

--
-- Name: persons; Type: TABLE; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

CREATE TABLE persons (
    sampno integer NOT NULL,
    perno integer NOT NULL,
    fname character varying(125),
    lname character varying(125),
    age integer,
    ageb integer,
    proxy integer,
    agec character(10),
    gpseligible integer
);


ALTER TABLE arc_tbw.persons OWNER TO postgres;

--
-- Name: places; Type: TABLE; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

CREATE TABLE places (
    sampno integer NOT NULL,
    perno integer NOT NULL,
    guid uuid,
    placeno integer NOT NULL,
    locno integer,
    gpsfileid uuid,
    starttime timestamp without time zone,
    arrtime timestamp without time zone,
    deptime timestamp without time zone,
    travtime double precision,
    actdur double precision,
    mode integer,
    confirmed integer,
    sourceguid uuid,
    sourceperno integer,
    routewaypoints text,
    routeshapepoints text,
    distance double precision,
    traveldayno integer NOT NULL,
    gpsfileuuid uuid,
    guiduuid uuid
);


ALTER TABLE arc_tbw.places OWNER TO postgres;

--
-- Name: placestripimputevariables; Type: TABLE; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

CREATE TABLE placestripimputevariables (
    sampno integer NOT NULL,
    perno integer NOT NULL,
    placeno integer NOT NULL,
    iswalkorwheelchair boolean,
    nonauto boolean,
    tripdistance double precision,
    tottr integer,
    pretransfervar boolean,
    nonmand boolean,
    transfervariablebothnonauto boolean,
    transfervariableatleastonenonauto boolean,
    someonedropped boolean,
    someonepicked boolean,
    partysizechange boolean,
    mixedparty boolean,
    actdurless60min boolean,
    actdurless10min boolean,
    airportdestnotflying boolean,
    tripdistgreater10mi boolean,
    actdurgreater10min boolean,
    actdurless30min boolean,
    worklocationmatch boolean,
    schoollocationmatch boolean,
    adultparty boolean,
    childparty boolean,
    dropoffvariable boolean,
    pickupvariable boolean,
    hhmem integer,
    groupgroceryduration boolean,
    groupeatoutduration boolean,
    bikemode boolean,
    grouprecreationduration boolean,
    groupsocialvisitduration boolean,
    orig_taz integer,
    dest_taz integer,
    airport boolean,
    notworklocation boolean,
    outoftown boolean,
    airportpurpose boolean,
    schoolbusmode boolean,
    subtourdummy boolean,
    simplesubtour boolean,
    complexsubtour boolean,
    volunactdurless60min boolean,
    volunworklocationmatch boolean,
    adultactdurless100min boolean,
    schoolageactdurless150min boolean,
    preschoolactdurless300min boolean,
    ftworkeractdurless120min boolean,
    ptworkeractdurless120min boolean,
    univstudactdurless120min boolean,
    actdurgreater30min boolean,
    actdurgreater90min boolean,
    actdurgreater45min boolean,
    actdurgreater120min boolean,
    adultpartyactdur20to40min boolean,
    adultparty12pmto2pm boolean,
    actdur30to90min boolean,
    simplesubtour12pmto2pm boolean,
    complexsubtour12pmto2pm boolean,
    originisdestination boolean,
    actdurless120min boolean,
    actdurgreater150min boolean,
    starttime10amto1pm boolean,
    starttime11amto1pm boolean,
    starttime11amto3pm boolean,
    starttime1amto6pm boolean,
    starttime2pmto5pm boolean,
    starttime2pmto6pm boolean,
    starttime2pmto7pm boolean,
    starttime3pmto5pm boolean,
    starttime3pmto6pm boolean,
    starttime3pmto7pm boolean,
    starttime3pmto8pm boolean,
    starttime4pmto7pm boolean,
    starttime5pmto7pm boolean,
    starttime7amto12am boolean,
    starttime8amto11am boolean,
    starttime8amto12pm boolean,
    starttime8amto2pm boolean,
    starttime9amto11am boolean,
    starttime9amto3pm boolean,
    female boolean,
    young boolean,
    nondrivingchildren boolean,
    zerocars boolean,
    highincome boolean,
    lowincome boolean,
    naicsretail boolean,
    naicsinformation boolean,
    naicsfinance boolean,
    naicsrealestate boolean,
    naicshealthcare boolean,
    naicsarts boolean,
    naicsaccommodation boolean,
    naicsother boolean,
    naicspublicadmin boolean,
    k8enrollment boolean,
    highschoolenrollment boolean,
    totalhhs integer,
    distancetohome double precision,
    nondrivingchildrenontrip boolean
);


ALTER TABLE arc_tbw.placestripimputevariables OWNER TO postgres;

--
-- Name: placestripimputevariablesints; Type: TABLE; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

CREATE TABLE placestripimputevariablesints (
    sampno integer NOT NULL,
    perno integer NOT NULL,
    placeno integer NOT NULL,
    iswalkorwheelchair integer,
    nonauto integer,
    tripdistance double precision,
    tottr integer,
    pretransfervar integer,
    nonmand integer,
    transfervariablebothnonauto integer,
    transfervariableatleastonenonauto integer,
    someonedropped integer,
    someonepicked integer,
    partysizechange integer,
    mixedparty integer,
    actdurless60min integer,
    actdurless10min integer,
    airportdestnotflying integer,
    tripdistgreater10mi integer,
    actdurgreater10min integer,
    actdurless30min integer,
    worklocationmatch integer,
    schoollocationmatch integer,
    adultparty integer,
    childparty integer,
    dropoffvariable integer,
    pickupvariable integer,
    hhmem integer,
    groupgroceryduration integer,
    groupeatoutduration integer,
    bikemode integer,
    grouprecreationduration integer,
    groupsocialvisitduration integer,
    orig_taz integer,
    dest_taz integer,
    airport integer,
    notworklocation integer,
    outoftown integer,
    airportpurpose integer,
    schoolbusmode integer,
    subtourdummy integer,
    simplesubtour integer,
    complexsubtour integer,
    volunactdurless60min integer,
    volunworklocationmatch integer,
    adultactdurless100min integer,
    schoolageactdurless150min integer,
    preschoolactdurless300min integer,
    ftworkeractdurless120min integer,
    ptworkeractdurless120min integer,
    univstudactdurless120min integer,
    actdurgreater30min integer,
    actdurgreater90min integer,
    actdurgreater45min integer,
    actdurgreater120min integer,
    adultpartyactdur20to40min integer,
    adultparty12pmto2pm integer,
    actdur30to90min integer,
    simplesubtour12pmto2pm integer,
    complexsubtour12pmto2pm integer,
    originisdestination integer,
    actdurless120min integer,
    actdurgreater150min integer,
    starttime10amto1pm integer,
    starttime11amto1pm integer,
    starttime11amto3pm integer,
    starttime1amto6pm integer,
    starttime2pmto5pm integer,
    starttime2pmto6pm integer,
    starttime2pmto7pm integer,
    starttime3pmto5pm integer,
    starttime3pmto6pm integer,
    starttime3pmto7pm integer,
    starttime3pmto8pm integer,
    starttime4pmto7pm integer,
    starttime5pmto7pm integer,
    starttime7amto12am integer,
    starttime8amto11am integer,
    starttime8amto12pm integer,
    starttime8amto2pm integer,
    starttime9amto11am integer,
    starttime9amto3pm integer,
    female integer,
    young integer,
    nondrivingchildren integer,
    zerocars integer,
    highincome integer,
    lowincome integer,
    naicsretail integer,
    naicsinformation integer,
    naicsfinance integer,
    naicsrealestate integer,
    naicshealthcare integer,
    naicsarts integer,
    naicsaccommodation integer,
    naicsother integer,
    naicspublicadmin integer,
    k8enrollment integer,
    highschoolenrollment integer,
    totalhhs integer,
    distancetohome double precision,
    nondrivingchildrenontrip integer,
    nearbigbox integer DEFAULT 0 NOT NULL,
    nearchurch integer DEFAULT 0 NOT NULL,
    lu_institutional integer DEFAULT 0 NOT NULL,
    lu_commercial integer DEFAULT 0 NOT NULL,
    nearschool integer DEFAULT 0
);


ALTER TABLE arc_tbw.placestripimputevariablesints OWNER TO postgres;

--
-- Name: subtours; Type: TABLE; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

CREATE TABLE subtours (
    sampno integer NOT NULL,
    perno integer NOT NULL,
    startplaceno integer NOT NULL,
    endplaceno integer,
    maintourstartplaceno integer
);


ALTER TABLE arc_tbw.subtours OWNER TO postgres;

--
-- Name: tours; Type: TABLE; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

CREATE TABLE tours (
    sampno integer NOT NULL,
    perno integer NOT NULL,
    startplaceno integer NOT NULL,
    endplaceno integer
);


ALTER TABLE arc_tbw.tours OWNER TO postgres;

--
-- Name: vehicles; Type: TABLE; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

CREATE TABLE vehicles (
    sampno integer NOT NULL,
    vehno integer NOT NULL,
    driverperno integer,
    vmake character varying(125),
    vmodel character varying(125),
    vyear integer,
    vyearc integer,
    vmakec integer
);


ALTER TABLE arc_tbw.vehicles OWNER TO postgres;

--
-- Name: travelmodes; Type: TABLE; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

CREATE TABLE travelmodes (
    modeid integer NOT NULL,
    name character varying(255),
    avgspeed double precision,
    stdspeed double precision,
    maxspeed double precision,
    istransit integer,
    iswalk integer,
    isdriver integer,
    ispassenger integer,
    allowableroommins integer
);


ALTER TABLE arc_tbw.travelmodes OWNER TO postgres;

--
-- Name: households_pkey; Type: CONSTRAINT; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY households
    ADD CONSTRAINT households_pkey PRIMARY KEY (sampno);


--
-- Name: householdsextended_pkey; Type: CONSTRAINT; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY householdsextended
    ADD CONSTRAINT householdsextended_pkey PRIMARY KEY (sampno);


--
-- Name: locations_pkey; Type: CONSTRAINT; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (sampno, locno);


--
-- Name: personextended_pkey; Type: CONSTRAINT; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY personextended
    ADD CONSTRAINT personextended_pkey PRIMARY KEY (sampno, perno);


--
-- Name: persons_pkey; Type: CONSTRAINT; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY persons
    ADD CONSTRAINT persons_pkey PRIMARY KEY (sampno, perno);


--
-- Name: places_pkey; Type: CONSTRAINT; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY places
    ADD CONSTRAINT places_pkey PRIMARY KEY (sampno, perno, placeno);


--
-- Name: placestripimputevariables_pkey; Type: CONSTRAINT; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY placestripimputevariables
    ADD CONSTRAINT placestripimputevariables_pkey PRIMARY KEY (sampno, perno, placeno);


--
-- Name: placestripimputevariablesints_pkey; Type: CONSTRAINT; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY placestripimputevariablesints
    ADD CONSTRAINT placestripimputevariablesints_pkey PRIMARY KEY (sampno, perno, placeno);


--
-- Name: subtours_pkey; Type: CONSTRAINT; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subtours
    ADD CONSTRAINT subtours_pkey PRIMARY KEY (sampno, perno, startplaceno);


--
-- Name: tours_pkey; Type: CONSTRAINT; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tours
    ADD CONSTRAINT tours_pkey PRIMARY KEY (sampno, perno, startplaceno);


--
-- Name: travelmodes_pkey; Type: CONSTRAINT; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY travelmodes
    ADD CONSTRAINT travelmodes_pkey PRIMARY KEY (modeid);


--
-- Name: vehicles_pkey; Type: CONSTRAINT; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY vehicles
    ADD CONSTRAINT vehicles_pkey PRIMARY KEY (sampno, vehno);


--
-- Name: locations_geom_gist; Type: INDEX; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

CREATE INDEX locations_geom_gist ON locations USING gist (geom);


--
-- Name: locations_lng_lat; Type: INDEX; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

CREATE INDEX locations_lng_lat ON locations USING btree (longitude, latitude);


--
-- Name: personextended_sampno_perno_idx; Type: INDEX; Schema: arc_tbw; Owner: postgres; Tablespace: 
--

CREATE INDEX personextended_sampno_perno_idx ON personextended USING btree (sampno, perno);


--
-- Name: households; Type: ACL; Schema: arc_tbw; Owner: postgres
--

REVOKE ALL ON TABLE households FROM PUBLIC;
REVOKE ALL ON TABLE households FROM postgres;
GRANT ALL ON TABLE households TO postgres;


--
-- Name: householdsextended; Type: ACL; Schema: arc_tbw; Owner: postgres
--

REVOKE ALL ON TABLE householdsextended FROM PUBLIC;
REVOKE ALL ON TABLE householdsextended FROM postgres;
GRANT ALL ON TABLE householdsextended TO postgres;


--
-- Name: locations; Type: ACL; Schema: arc_tbw; Owner: postgres
--

REVOKE ALL ON TABLE locations FROM PUBLIC;
REVOKE ALL ON TABLE locations FROM postgres;
GRANT ALL ON TABLE locations TO postgres;


--
-- Name: personextended; Type: ACL; Schema: arc_tbw; Owner: postgres
--

REVOKE ALL ON TABLE personextended FROM PUBLIC;
REVOKE ALL ON TABLE personextended FROM postgres;
GRANT ALL ON TABLE personextended TO postgres;


--
-- Name: persons; Type: ACL; Schema: arc_tbw; Owner: postgres
--

REVOKE ALL ON TABLE persons FROM PUBLIC;
REVOKE ALL ON TABLE persons FROM postgres;
GRANT ALL ON TABLE persons TO postgres;


--
-- Name: places; Type: ACL; Schema: arc_tbw; Owner: postgres
--

REVOKE ALL ON TABLE places FROM PUBLIC;
REVOKE ALL ON TABLE places FROM postgres;
GRANT ALL ON TABLE places TO postgres;


--
-- Name: vehicles; Type: ACL; Schema: arc_tbw; Owner: postgres
--

REVOKE ALL ON TABLE vehicles FROM PUBLIC;
REVOKE ALL ON TABLE vehicles FROM postgres;
GRANT ALL ON TABLE vehicles TO postgres;


--
-- Name: travelmodes; Type: ACL; Schema: arc_tbw; Owner: postgres
--

REVOKE ALL ON TABLE travelmodes FROM PUBLIC;
REVOKE ALL ON TABLE travelmodes FROM postgres;
GRANT ALL ON TABLE travelmodes TO postgres;


--
-- PostgreSQL database dump complete
--

