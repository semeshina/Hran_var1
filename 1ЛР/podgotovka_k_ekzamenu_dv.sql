SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `podgotovka_k_ekzamenu_dv`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;
USE `podgotovka_k_ekzamenu_dv`;

-- =====================================================================
-- HUBS
-- =====================================================================

CREATE TABLE IF NOT EXISTS `hub_kategoriya_ekzamena` (
  `kategoriya_hk` CHAR(32) NOT NULL,
  `kod`           VARCHAR(5) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`kategoriya_hk`),
  UNIQUE INDEX `hub_kategoriya_ekzamena_bk_UNIQUE` (`kod` ASC) VISIBLE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `hub_tip_materiala` (
  `tip_materiala_hk` CHAR(32) NOT NULL,
  `nazvanie`         VARCHAR(60) NOT NULL,
  `load_date`        DATETIME NOT NULL,
  `record_source`    VARCHAR(100) NOT NULL,
  PRIMARY KEY (`tip_materiala_hk`),
  UNIQUE INDEX `hub_tip_materiala_bk_UNIQUE` (`nazvanie` ASC) VISIBLE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `hub_dolzhnost` (
  `dolzhnost_hk`  CHAR(32) NOT NULL,
  `nazvanie`      VARCHAR(45) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`dolzhnost_hk`),
  UNIQUE INDEX `hub_dolzhnost_bk_UNIQUE` (`nazvanie` ASC) VISIBLE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `hub_prepodavatel` (
  `prepodavatel_hk` CHAR(32) NOT NULL,
  `telefon`         VARCHAR(15) NOT NULL,
  `load_date`       DATETIME NOT NULL,
  `record_source`   VARCHAR(100) NOT NULL,
  PRIMARY KEY (`prepodavatel_hk`),
  UNIQUE INDEX `hub_prepodavatel_bk_UNIQUE` (`telefon` ASC) VISIBLE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `hub_student` (
  `student_hk`    CHAR(32) NOT NULL,
  `telefon`       VARCHAR(15) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`student_hk`),
  UNIQUE INDEX `hub_student_bk_UNIQUE` (`telefon` ASC) VISIBLE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `hub_etap` (
  `etap_hk`        CHAR(32) NOT NULL,
  `kategoriya_kod` VARCHAR(5) NOT NULL,
  `nomer_shaga`    TINYINT NOT NULL,
  `load_date`      DATETIME NOT NULL,
  `record_source`  VARCHAR(100) NOT NULL,
  PRIMARY KEY (`etap_hk`),
  UNIQUE INDEX `hub_etap_bk_UNIQUE` (`kategoriya_kod` ASC, `nomer_shaga` ASC) VISIBLE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `hub_gruppa` (
  `gruppa_hk`     CHAR(32) NOT NULL,
  `nazvanie`      VARCHAR(45) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`gruppa_hk`),
  UNIQUE INDEX `hub_gruppa_bk_UNIQUE` (`nazvanie` ASC) VISIBLE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `hub_status` (
  `status_hk`     CHAR(32) NOT NULL,
  `nazvanie`      VARCHAR(30) NOT NULL,
  `tip_statusa`   VARCHAR(20) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`status_hk`),
  UNIQUE INDEX `hub_status_bk_UNIQUE` (`nazvanie` ASC, `tip_statusa` ASC) VISIBLE
) ENGINE = InnoDB;

-- =====================================================================
-- LINKS
-- =====================================================================

CREATE TABLE IF NOT EXISTS `link_prepodavatel_dolzhnost` (
  `link_prep_dolzh_hk` CHAR(32) NOT NULL,
  `prepodavatel_hk`    CHAR(32) NOT NULL,
  `dolzhnost_hk`       CHAR(32) NOT NULL,
  `load_date`          DATETIME NOT NULL,
  `record_source`      VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_prep_dolzh_hk`),
  UNIQUE INDEX `link_prepodavatel_dolzhnost_uniq_UNIQUE`
    (`prepodavatel_hk` ASC, `dolzhnost_hk` ASC) VISIBLE,
  INDEX `fk_link_prep_dolzh_prep_idx` (`prepodavatel_hk` ASC) VISIBLE,
  INDEX `fk_link_prep_dolzh_dolzh_idx` (`dolzhnost_hk` ASC) VISIBLE,
  CONSTRAINT `fk_link_prep_dolzh_prep`
    FOREIGN KEY (`prepodavatel_hk`) REFERENCES `hub_prepodavatel` (`prepodavatel_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_link_prep_dolzh_dolzh`
    FOREIGN KEY (`dolzhnost_hk`) REFERENCES `hub_dolzhnost` (`dolzhnost_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `link_etap_material` (
  `link_etap_mat_hk`   CHAR(32) NOT NULL,
  `etap_hk`            CHAR(32) NOT NULL,
  `tip_materiala_hk`   CHAR(32) NOT NULL,
  `load_date`          DATETIME NOT NULL,
  `record_source`      VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_etap_mat_hk`),
  UNIQUE INDEX `link_etap_material_uniq_UNIQUE`
    (`etap_hk` ASC, `tip_materiala_hk` ASC) VISIBLE,
  INDEX `fk_link_etap_mat_etap_idx` (`etap_hk` ASC) VISIBLE,
  INDEX `fk_link_etap_mat_tip_idx`  (`tip_materiala_hk` ASC) VISIBLE,
  CONSTRAINT `fk_link_etap_mat_etap`
    FOREIGN KEY (`etap_hk`) REFERENCES `hub_etap` (`etap_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_link_etap_mat_tip`
    FOREIGN KEY (`tip_materiala_hk`) REFERENCES `hub_tip_materiala` (`tip_materiala_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `link_student_material` (
  `link_stud_mat_hk` CHAR(32) NOT NULL,
  `student_hk`       CHAR(32) NOT NULL,
  `tip_materiala_hk` CHAR(32) NOT NULL,
  `nomer`            VARCHAR(20) NOT NULL,
  `load_date`        DATETIME NOT NULL,
  `record_source`    VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_stud_mat_hk`),
  UNIQUE INDEX `link_student_material_uniq_UNIQUE`
    (`student_hk` ASC, `tip_materiala_hk` ASC, `nomer` ASC) VISIBLE,
  INDEX `fk_link_stud_mat_student_idx` (`student_hk` ASC) VISIBLE,
  INDEX `fk_link_stud_mat_tip_idx`     (`tip_materiala_hk` ASC) VISIBLE,
  CONSTRAINT `fk_link_stud_mat_student`
    FOREIGN KEY (`student_hk`) REFERENCES `hub_student` (`student_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_link_stud_mat_tip`
    FOREIGN KEY (`tip_materiala_hk`) REFERENCES `hub_tip_materiala` (`tip_materiala_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `link_spravka_o_gotovnosti` (
  `link_spravka_hk` CHAR(32) NOT NULL,
  `student_hk`      CHAR(32) NOT NULL,
  `nomer`           VARCHAR(30) NOT NULL,
  `load_date`       DATETIME NOT NULL,
  `record_source`   VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_spravka_hk`),
  UNIQUE INDEX `link_spravka_uniq_UNIQUE`
    (`student_hk` ASC, `nomer` ASC) VISIBLE,
  INDEX `fk_link_spravka_student_idx` (`student_hk` ASC) VISIBLE,
  CONSTRAINT `fk_link_spravka_student`
    FOREIGN KEY (`student_hk`) REFERENCES `hub_student` (`student_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `link_gruppa_podgotovki` (
  `link_gruppa_podg_hk` CHAR(32) NOT NULL,
  `gruppa_hk`           CHAR(32) NOT NULL,
  `kategoriya_hk`       CHAR(32) NOT NULL,
  `prepodavatel_hk`     CHAR(32) NOT NULL,
  `load_date`           DATETIME NOT NULL,
  `record_source`       VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_gruppa_podg_hk`),
  UNIQUE INDEX `link_gruppa_podgotovki_uniq_UNIQUE`
    (`gruppa_hk` ASC, `kategoriya_hk` ASC, `prepodavatel_hk` ASC) VISIBLE,
  INDEX `fk_link_gruppa_gruppa_idx`       (`gruppa_hk` ASC) VISIBLE,
  INDEX `fk_link_gruppa_kategoriya_idx`   (`kategoriya_hk` ASC) VISIBLE,
  INDEX `fk_link_gruppa_prepodavatel_idx` (`prepodavatel_hk` ASC) VISIBLE,
  CONSTRAINT `fk_link_gruppa_gruppa`
    FOREIGN KEY (`gruppa_hk`) REFERENCES `hub_gruppa` (`gruppa_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_link_gruppa_kategoriya`
    FOREIGN KEY (`kategoriya_hk`) REFERENCES `hub_kategoriya_ekzamena` (`kategoriya_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_link_gruppa_prepodavatel`
    FOREIGN KEY (`prepodavatel_hk`) REFERENCES `hub_prepodavatel` (`prepodavatel_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `link_plan_podgotovki` (
  `link_plan_hk`     CHAR(32) NOT NULL,
  `student_hk`       CHAR(32) NOT NULL,
  `kategoriya_hk`    CHAR(32) NOT NULL,
  `prepodavatel_hk`  CHAR(32) NOT NULL,
  `status_hk`        CHAR(32) NOT NULL,
  `nomer_plana`      VARCHAR(20) NOT NULL,
  `load_date`        DATETIME NOT NULL,
  `record_source`    VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_plan_hk`),
  UNIQUE INDEX `link_plan_uniq_UNIQUE`
    (`student_hk` ASC, `kategoriya_hk` ASC, `prepodavatel_hk` ASC, `status_hk` ASC, `nomer_plana` ASC) VISIBLE,
  INDEX `fk_link_plan_student_idx`     (`student_hk` ASC) VISIBLE,
  INDEX `fk_link_plan_kategoriya_idx`  (`kategoriya_hk` ASC) VISIBLE,
  INDEX `fk_link_plan_prepodavatel_idx` (`prepodavatel_hk` ASC) VISIBLE,
  INDEX `fk_link_plan_status_idx`      (`status_hk` ASC) VISIBLE,
  CONSTRAINT `fk_link_plan_student`
    FOREIGN KEY (`student_hk`) REFERENCES `hub_student` (`student_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_link_plan_kategoriya`
    FOREIGN KEY (`kategoriya_hk`) REFERENCES `hub_kategoriya_ekzamena` (`kategoriya_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_link_plan_prepodavatel`
    FOREIGN KEY (`prepodavatel_hk`) REFERENCES `hub_prepodavatel` (`prepodavatel_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_link_plan_status`
    FOREIGN KEY (`status_hk`) REFERENCES `hub_status` (`status_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `link_prokhozhdenie_etapa` (
  `link_prokhozhdenie_hk` CHAR(32) NOT NULL,
  `link_plan_hk`          CHAR(32) NOT NULL,
  `etap_hk`               CHAR(32) NOT NULL,
  `load_date`             DATETIME NOT NULL,
  `record_source`         VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_prokhozhdenie_hk`),
  UNIQUE INDEX `link_prokhozhdenie_etapa_uniq_UNIQUE`
    (`link_plan_hk` ASC, `etap_hk` ASC) VISIBLE,
  INDEX `fk_link_prokh_plan_idx` (`link_plan_hk` ASC) VISIBLE,
  INDEX `fk_link_prokh_etap_idx` (`etap_hk` ASC) VISIBLE,
  CONSTRAINT `fk_link_prokh_plan`
    FOREIGN KEY (`link_plan_hk`) REFERENCES `link_plan_podgotovki` (`link_plan_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_link_prokh_etap`
    FOREIGN KEY (`etap_hk`) REFERENCES `hub_etap` (`etap_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `link_zachislenie` (
  `link_zachislenie_hk` CHAR(32) NOT NULL,
  `link_plan_hk`        CHAR(32) NOT NULL,
  `gruppa_hk`           CHAR(32) NOT NULL,
  `kurator_hk`          CHAR(32) NOT NULL,
  `load_date`           DATETIME NOT NULL,
  `record_source`       VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_zachislenie_hk`),
  UNIQUE INDEX `link_zachislenie_uniq_UNIQUE`
    (`link_plan_hk` ASC, `gruppa_hk` ASC, `kurator_hk` ASC) VISIBLE,
  INDEX `fk_link_zach_plan_idx`    (`link_plan_hk` ASC) VISIBLE,
  INDEX `fk_link_zach_gruppa_idx`  (`gruppa_hk` ASC) VISIBLE,
  INDEX `fk_link_zach_kurator_idx` (`kurator_hk` ASC) VISIBLE,
  CONSTRAINT `fk_link_zach_plan`
    FOREIGN KEY (`link_plan_hk`) REFERENCES `link_plan_podgotovki` (`link_plan_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_link_zach_gruppa`
    FOREIGN KEY (`gruppa_hk`) REFERENCES `hub_gruppa` (`gruppa_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_link_zach_kurator`
    FOREIGN KEY (`kurator_hk`) REFERENCES `hub_prepodavatel` (`prepodavatel_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `link_kontrolnyy_test` (
  `link_test_hk`     CHAR(32) NOT NULL,
  `link_plan_hk`     CHAR(32) NOT NULL,
  `ekzamenator_hk`   CHAR(32) NOT NULL,
  `tip_testa`        VARCHAR(20) NOT NULL,
  `nomer_popytki`    TINYINT NOT NULL,
  `load_date`        DATETIME NOT NULL,
  `record_source`    VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_test_hk`),
  UNIQUE INDEX `link_test_uniq_UNIQUE`
    (`link_plan_hk` ASC, `ekzamenator_hk` ASC, `tip_testa` ASC, `nomer_popytki` ASC) VISIBLE,
  INDEX `fk_link_test_plan_idx`       (`link_plan_hk` ASC) VISIBLE,
  INDEX `fk_link_test_ekzamenator_idx` (`ekzamenator_hk` ASC) VISIBLE,
  CONSTRAINT `fk_link_test_plan`
    FOREIGN KEY (`link_plan_hk`) REFERENCES `link_plan_podgotovki` (`link_plan_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_link_test_ekzamenator`
    FOREIGN KEY (`ekzamenator_hk`) REFERENCES `hub_prepodavatel` (`prepodavatel_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `link_platezh` (
  `link_platezh_hk` CHAR(32) NOT NULL,
  `link_plan_hk`    CHAR(32) NOT NULL,
  `nomer_platezha`  VARCHAR(20) NOT NULL,
  `load_date`       DATETIME NOT NULL,
  `record_source`   VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_platezh_hk`),
  UNIQUE INDEX `link_platezh_uniq_UNIQUE`
    (`link_plan_hk` ASC, `nomer_platezha` ASC) VISIBLE,
  INDEX `fk_link_platezh_plan_idx` (`link_plan_hk` ASC) VISIBLE,
  CONSTRAINT `fk_link_platezh_plan`
    FOREIGN KEY (`link_plan_hk`) REFERENCES `link_plan_podgotovki` (`link_plan_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `link_sertifikat` (
  `link_sertifikat_hk` CHAR(32) NOT NULL,
  `link_plan_hk`       CHAR(32) NOT NULL,
  `nomer`              VARCHAR(20) NOT NULL,
  `load_date`          DATETIME NOT NULL,
  `record_source`      VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_sertifikat_hk`),
  UNIQUE INDEX `link_sertifikat_uniq_UNIQUE`
    (`link_plan_hk` ASC, `nomer` ASC) VISIBLE,
  INDEX `fk_link_sertifikat_plan_idx` (`link_plan_hk` ASC) VISIBLE,
  CONSTRAINT `fk_link_sertifikat_plan`
    FOREIGN KEY (`link_plan_hk`) REFERENCES `link_plan_podgotovki` (`link_plan_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

-- =====================================================================
-- SATELLITES
-- =====================================================================

CREATE TABLE IF NOT EXISTS `sat_kategoriya_ekzamena` (
  `kategoriya_hk` CHAR(32) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `load_end_date` DATETIME NULL,
  `hash_diff`     CHAR(32) NOT NULL,
  `nazvanie`      VARCHAR(100) NOT NULL,
  `min_uroven`    TINYINT NOT NULL,
  `opisanie`      VARCHAR(255) NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`kategoriya_hk`, `load_date`),
  CONSTRAINT `fk_sat_kategoriya_parent`
    FOREIGN KEY (`kategoriya_hk`) REFERENCES `hub_kategoriya_ekzamena` (`kategoriya_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_etap` (
  `etap_hk`           CHAR(32) NOT NULL,
  `load_date`         DATETIME NOT NULL,
  `load_end_date`     DATETIME NULL,
  `hash_diff`         CHAR(32) NOT NULL,
  `nazvanie`          VARCHAR(100) NOT NULL,
  `opisanie`          VARCHAR(500) NULL,
  `organizatsiya`     VARCHAR(100) NULL,
  `obyazatelnyy`      TINYINT(1) NOT NULL DEFAULT 1,
  `srok_dney`         SMALLINT NULL,
  `kriterii_otlichno` VARCHAR(255) NULL,
  `record_source`     VARCHAR(100) NOT NULL,
  PRIMARY KEY (`etap_hk`, `load_date`),
  CONSTRAINT `fk_sat_etap_parent`
    FOREIGN KEY (`etap_hk`) REFERENCES `hub_etap` (`etap_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_etap_material` (
  `link_etap_mat_hk` CHAR(32) NOT NULL,
  `load_date`        DATETIME NOT NULL,
  `load_end_date`    DATETIME NULL,
  `hash_diff`        CHAR(32) NOT NULL,
  `obyazatelnyy`     TINYINT(1) NOT NULL DEFAULT 1,
  `record_source`    VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_etap_mat_hk`, `load_date`),
  CONSTRAINT `fk_sat_etap_material_parent`
    FOREIGN KEY (`link_etap_mat_hk`) REFERENCES `link_etap_material` (`link_etap_mat_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_prepodavatel` (
  `prepodavatel_hk` CHAR(32) NOT NULL,
  `load_date`       DATETIME NOT NULL,
  `load_end_date`   DATETIME NULL,
  `hash_diff`       CHAR(32) NOT NULL,
  `imya`            VARCHAR(45) NOT NULL,
  `familiya`        VARCHAR(45) NOT NULL,
  `otchestvo`       VARCHAR(45) NULL,
  `email`           VARCHAR(60) NULL,
  `record_source`   VARCHAR(100) NOT NULL,
  PRIMARY KEY (`prepodavatel_hk`, `load_date`),
  CONSTRAINT `fk_sat_prepodavatel_parent`
    FOREIGN KEY (`prepodavatel_hk`) REFERENCES `hub_prepodavatel` (`prepodavatel_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_student` (
  `student_hk`        CHAR(32) NOT NULL,
  `load_date`         DATETIME NOT NULL,
  `load_end_date`     DATETIME NULL,
  `hash_diff`         CHAR(32) NOT NULL,
  `imya`              VARCHAR(45) NOT NULL,
  `familiya`          VARCHAR(45) NOT NULL,
  `otchestvo`         VARCHAR(45) NULL,
  `data_rozhdeniya`   DATE NOT NULL,
  `email`             VARCHAR(60) NULL,
  `adres`             VARCHAR(255) NULL,
  `data_registratsii` DATE NOT NULL,
  `record_source`     VARCHAR(100) NOT NULL,
  PRIMARY KEY (`student_hk`, `load_date`),
  CONSTRAINT `fk_sat_student_parent`
    FOREIGN KEY (`student_hk`) REFERENCES `hub_student` (`student_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_material_studenta` (
  `link_stud_mat_hk` CHAR(32) NOT NULL,
  `load_date`        DATETIME NOT NULL,
  `load_end_date`    DATETIME NULL,
  `hash_diff`        CHAR(32) NOT NULL,
  `nazvanie`         VARCHAR(100) NULL,
  `istochnik`        VARCHAR(255) NULL,
  `data_polucheniya` DATE NULL,
  `data_aktualnosti` DATE NULL,
  `record_source`    VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_stud_mat_hk`, `load_date`),
  CONSTRAINT `fk_sat_material_parent`
    FOREIGN KEY (`link_stud_mat_hk`) REFERENCES `link_student_material` (`link_stud_mat_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_spravka_o_gotovnosti` (
  `link_spravka_hk`  CHAR(32) NOT NULL,
  `load_date`        DATETIME NOT NULL,
  `load_end_date`    DATETIME NULL,
  `hash_diff`        CHAR(32) NOT NULL,
  `organizatsiya`    VARCHAR(150) NULL,
  `data_vydachi`     DATE NOT NULL,
  `data_okonchaniya` DATE NOT NULL,
  `gotov_k_ekzamenu` TINYINT(1) NOT NULL DEFAULT 0,
  `record_source`    VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_spravka_hk`, `load_date`),
  CONSTRAINT `fk_sat_spravka_parent`
    FOREIGN KEY (`link_spravka_hk`) REFERENCES `link_spravka_o_gotovnosti` (`link_spravka_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_gruppa` (
  `gruppa_hk`        CHAR(32) NOT NULL,
  `load_date`        DATETIME NOT NULL,
  `load_end_date`    DATETIME NULL,
  `hash_diff`        CHAR(32) NOT NULL,
  `data_nachala`     DATE NOT NULL,
  `data_okonchaniya` DATE NULL,
  `record_source`    VARCHAR(100) NOT NULL,
  PRIMARY KEY (`gruppa_hk`, `load_date`),
  CONSTRAINT `fk_sat_gruppa_parent`
    FOREIGN KEY (`gruppa_hk`) REFERENCES `hub_gruppa` (`gruppa_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_plan_podgotovki` (
  `link_plan_hk`  CHAR(32) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `load_end_date` DATETIME NULL,
  `hash_diff`     CHAR(32) NOT NULL,
  `data_nachala`  DATE NOT NULL,
  `primechanie`   VARCHAR(255) NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_plan_hk`, `load_date`),
  CONSTRAINT `fk_sat_plan_parent`
    FOREIGN KEY (`link_plan_hk`) REFERENCES `link_plan_podgotovki` (`link_plan_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_prokhozhdenie_etapa` (
  `link_prokhozhdenie_hk` CHAR(32) NOT NULL,
  `load_date`             DATETIME NOT NULL,
  `load_end_date`         DATETIME NULL,
  `hash_diff`             CHAR(32) NOT NULL,
  `status`                ENUM('ozhidaet','v_protsesse','proyden','ne_proyden') NOT NULL DEFAULT 'ozhidaet',
  `data_nachala`          DATE NULL,
  `data_zaversheniya`     DATE NULL,
  `otsenka`               TINYINT NULL,
  `komentariy`            VARCHAR(255) NULL,
  `record_source`         VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_prokhozhdenie_hk`, `load_date`),
  CONSTRAINT `fk_sat_prokh_parent`
    FOREIGN KEY (`link_prokhozhdenie_hk`) REFERENCES `link_prokhozhdenie_etapa` (`link_prokhozhdenie_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_zachislenie` (
  `link_zachislenie_hk` CHAR(32) NOT NULL,
  `load_date`           DATETIME NOT NULL,
  `load_end_date`       DATETIME NULL,
  `hash_diff`           CHAR(32) NOT NULL,
  `chasov_teorii`       SMALLINT NOT NULL DEFAULT 0,
  `chasov_praktiki`     SMALLINT NOT NULL DEFAULT 0,
  `record_source`       VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_zachislenie_hk`, `load_date`),
  CONSTRAINT `fk_sat_zachislenie_parent`
    FOREIGN KEY (`link_zachislenie_hk`) REFERENCES `link_zachislenie` (`link_zachislenie_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_kontrolnyy_test` (
  `link_test_hk`     CHAR(32) NOT NULL,
  `load_date`        DATETIME NOT NULL,
  `load_end_date`    DATETIME NULL,
  `hash_diff`        CHAR(32) NOT NULL,
  `data_testa`       DATETIME NOT NULL,
  `kolvo_oshibok`    TINYINT NULL,
  `otsenka`          TINYINT NULL,
  `sdan_na_otlichno` TINYINT(1) NOT NULL DEFAULT 0,
  `record_source`    VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_test_hk`, `load_date`),
  CONSTRAINT `fk_sat_test_parent`
    FOREIGN KEY (`link_test_hk`) REFERENCES `link_kontrolnyy_test` (`link_test_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_platezh` (
  `link_platezh_hk` CHAR(32) NOT NULL,
  `load_date`       DATETIME NOT NULL,
  `load_end_date`   DATETIME NULL,
  `hash_diff`       CHAR(32) NOT NULL,
  `summa`           DECIMAL(10,2) NOT NULL,
  `data_platezha`   DATETIME NOT NULL,
  `naznachenie`     ENUM('kurs','materialy','povtornyy_test') NOT NULL DEFAULT 'kurs',
  `sposob_nazvanie` VARCHAR(30) NOT NULL,
  `record_source`   VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_platezh_hk`, `load_date`),
  CONSTRAINT `fk_sat_platezh_parent`
    FOREIGN KEY (`link_platezh_hk`) REFERENCES `link_platezh` (`link_platezh_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_sertifikat` (
  `link_sertifikat_hk` CHAR(32) NOT NULL,
  `load_date`          DATETIME NOT NULL,
  `load_end_date`      DATETIME NULL,
  `hash_diff`          CHAR(32) NOT NULL,
  `data_vydachi`       DATE NOT NULL,
  `data_okonchaniya`   DATE NOT NULL,
  `podrazdelenie`      VARCHAR(150) NULL,
  `itogovaya_otsenka`  TINYINT NOT NULL DEFAULT 5,
  `record_source`      VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_sertifikat_hk`, `load_date`),
  CONSTRAINT `fk_sat_sertifikat_parent`
    FOREIGN KEY (`link_sertifikat_hk`) REFERENCES `link_sertifikat` (`link_sertifikat_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
