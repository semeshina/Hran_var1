SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `podgotovka_k_ekzamenu`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;
USE `podgotovka_k_ekzamenu`;

-- ---------------------------------------------------------------
-- Справочники
-- ---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `kategoriya_ekzamena` (
  `id`              INT NOT NULL AUTO_INCREMENT,
  `kod`             VARCHAR(5) NOT NULL,
  `nazvanie`        VARCHAR(100) NOT NULL,
  `min_uroven`      TINYINT NOT NULL COMMENT 'Минимальный уровень подготовки (1-5)',
  `opisanie`        VARCHAR(255) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `kategoriya_ekzamena_kod_UNIQUE` (`kod` ASC) VISIBLE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `tip_materiala` (
  `id`       INT NOT NULL AUTO_INCREMENT,
  `nazvanie` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `tip_materiala_nazvanie_UNIQUE` (`nazvanie` ASC) VISIBLE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `status_plana` (
  `id`       INT NOT NULL AUTO_INCREMENT,
  `nazvanie` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `status_plana_nazvanie_UNIQUE` (`nazvanie` ASC) VISIBLE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sposob_oplaty` (
  `id`       INT NOT NULL AUTO_INCREMENT,
  `nazvanie` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `sposob_oplaty_nazvanie_UNIQUE` (`nazvanie` ASC) VISIBLE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `dolzhnost` (
  `id`       INT NOT NULL AUTO_INCREMENT,
  `nazvanie` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `dolzhnost_nazvanie_UNIQUE` (`nazvanie` ASC) VISIBLE
) ENGINE = InnoDB;

-- ---------------------------------------------------------------
-- Описание порядка подготовки (этапы для отличной оценки)
-- ---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `etap_podgotovki` (
  `id`            INT NOT NULL AUTO_INCREMENT,
  `kategoriya_id` INT NOT NULL,
  `nomer_shaga`   TINYINT NOT NULL,
  `nazvanie`      VARCHAR(100) NOT NULL,
  `opisanie`      VARCHAR(500) NULL,
  `organizatsiya` VARCHAR(100) NULL COMMENT 'Кто проводит этап (преподаватель, самоподготовка и т.д.)',
  `obyazatelnyy`  TINYINT(1) NOT NULL DEFAULT 1,
  `srok_dney`     SMALLINT NULL,
  `kriterii_otlichno` VARCHAR(255) NULL COMMENT 'Критерии для получения отличной оценки на этапе',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `etap_kategoriya_shag_UNIQUE` (`kategoriya_id` ASC, `nomer_shaga` ASC) VISIBLE,
  CONSTRAINT `fk_etap_kategoriya`
    FOREIGN KEY (`kategoriya_id`) REFERENCES `kategoriya_ekzamena` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `etap_material` (
  `etap_id`          INT NOT NULL,
  `tip_materiala_id` INT NOT NULL,
  `obyazatelnyy`     TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`etap_id`, `tip_materiala_id`),
  INDEX `fk_etap_material_tip_idx` (`tip_materiala_id` ASC) VISIBLE,
  CONSTRAINT `fk_etap_material_etap`
    FOREIGN KEY (`etap_id`) REFERENCES `etap_podgotovki` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_etap_material_tip`
    FOREIGN KEY (`tip_materiala_id`) REFERENCES `tip_materiala` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

-- ---------------------------------------------------------------
-- Студенты и преподаватели
-- ---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `student` (
  `id`                INT NOT NULL AUTO_INCREMENT,
  `imya`              VARCHAR(45) NOT NULL,
  `familiya`          VARCHAR(45) NOT NULL,
  `otchestvo`         VARCHAR(45) NULL,
  `data_rozhdeniya`   DATE NOT NULL,
  `telefon`           VARCHAR(15) NOT NULL,
  `email`             VARCHAR(60) NULL,
  `adres`             VARCHAR(255) NULL,
  `data_registratsii` DATE NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `student_telefon_UNIQUE` (`telefon` ASC) VISIBLE,
  UNIQUE INDEX `student_email_UNIQUE`   (`email` ASC)   VISIBLE,
  INDEX `student_familiya_idx` (`familiya` ASC) VISIBLE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `material_studenta` (
  `id`               INT NOT NULL AUTO_INCREMENT,
  `student_id`       INT NOT NULL,
  `tip_materiala_id` INT NOT NULL,
  `nazvanie`         VARCHAR(100) NULL,
  `nomer`            VARCHAR(20) NOT NULL,
  `istochnik`        VARCHAR(255) NULL,
  `data_polucheniya` DATE NULL,
  `data_aktualnosti` DATE NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `material_nomer_UNIQUE` (`tip_materiala_id` ASC, `nomer` ASC) VISIBLE,
  INDEX `fk_material_student_idx` (`student_id` ASC) VISIBLE,
  CONSTRAINT `fk_material_student`
    FOREIGN KEY (`student_id`) REFERENCES `student` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_material_tip`
    FOREIGN KEY (`tip_materiala_id`) REFERENCES `tip_materiala` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `prepodavatel` (
  `id`           INT NOT NULL AUTO_INCREMENT,
  `imya`         VARCHAR(45) NOT NULL,
  `familiya`     VARCHAR(45) NOT NULL,
  `otchestvo`    VARCHAR(45) NULL,
  `telefon`      VARCHAR(15) NOT NULL,
  `email`        VARCHAR(60) NULL,
  `dolzhnost_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `prepodavatel_telefon_UNIQUE` (`telefon` ASC) VISIBLE,
  INDEX `fk_prepodavatel_dolzhnost_idx` (`dolzhnost_id` ASC) VISIBLE,
  CONSTRAINT `fk_prepodavatel_dolzhnost`
    FOREIGN KEY (`dolzhnost_id`) REFERENCES `dolzhnost` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

-- ---------------------------------------------------------------
-- План подготовки и прохождение этапов
-- ---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `plan_podgotovki` (
  `id`            INT NOT NULL AUTO_INCREMENT,
  `student_id`    INT NOT NULL,
  `kategoriya_id` INT NOT NULL,
  `prepodavatel_id` INT NOT NULL,
  `status_id`     INT NOT NULL,
  `data_nachala`  DATE NOT NULL,
  `primechanie`   VARCHAR(255) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_plan_student_idx`     (`student_id` ASC)    VISIBLE,
  INDEX `fk_plan_kategoriya_idx`  (`kategoriya_id` ASC) VISIBLE,
  INDEX `fk_plan_prepodavatel_idx` (`prepodavatel_id` ASC) VISIBLE,
  INDEX `fk_plan_status_idx`     (`status_id` ASC)     VISIBLE,
  CONSTRAINT `fk_plan_student`
    FOREIGN KEY (`student_id`) REFERENCES `student` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_plan_kategoriya`
    FOREIGN KEY (`kategoriya_id`) REFERENCES `kategoriya_ekzamena` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_plan_prepodavatel`
    FOREIGN KEY (`prepodavatel_id`) REFERENCES `prepodavatel` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_plan_status`
    FOREIGN KEY (`status_id`) REFERENCES `status_plana` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `prokhozhdenie_etapa` (
  `plan_id`          INT NOT NULL,
  `etap_id`          INT NOT NULL,
  `status`           ENUM('ozhidaet','v_protsesse','proyden','ne_proyden') NOT NULL DEFAULT 'ozhidaet',
  `data_nachala`     DATE NULL,
  `data_zaversheniya` DATE NULL,
  `otsenka`          TINYINT NULL COMMENT 'Оценка за этап (цель - 5)',
  `komentariy`       VARCHAR(255) NULL,
  PRIMARY KEY (`plan_id`, `etap_id`),
  INDEX `fk_prokhozhdenie_etap_idx` (`etap_id` ASC) VISIBLE,
  CONSTRAINT `fk_prokhozhdenie_plan`
    FOREIGN KEY (`plan_id`) REFERENCES `plan_podgotovki` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_prokhozhdenie_etap`
    FOREIGN KEY (`etap_id`) REFERENCES `etap_podgotovki` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `spravka_o_gotovnosti` (
  `id`               INT NOT NULL AUTO_INCREMENT,
  `student_id`       INT NOT NULL,
  `nomer`            VARCHAR(30) NOT NULL,
  `organizatsiya`    VARCHAR(150) NULL,
  `data_vydachi`     DATE NOT NULL,
  `data_okonchaniya` DATE NOT NULL,
  `gotov_k_ekzamenu` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Готов к экзамену на отлично',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `spravka_nomer_UNIQUE` (`nomer` ASC) VISIBLE,
  INDEX `fk_spravka_student_idx` (`student_id` ASC) VISIBLE,
  CONSTRAINT `fk_spravka_student`
    FOREIGN KEY (`student_id`) REFERENCES `student` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

-- ---------------------------------------------------------------
-- Группы, зачисление, контрольные тесты
-- ---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `gruppa_podgotovki` (
  `id`              INT NOT NULL AUTO_INCREMENT,
  `nazvanie`        VARCHAR(45) NOT NULL,
  `kategoriya_id`   INT NOT NULL,
  `prepodavatel_id` INT NOT NULL,
  `data_nachala`    DATE NOT NULL,
  `data_okonchaniya` DATE NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `gruppa_nazvanie_UNIQUE` (`nazvanie` ASC) VISIBLE,
  INDEX `fk_gruppa_kategoriya_idx`   (`kategoriya_id` ASC)   VISIBLE,
  INDEX `fk_gruppa_prepodavatel_idx` (`prepodavatel_id` ASC) VISIBLE,
  CONSTRAINT `fk_gruppa_kategoriya`
    FOREIGN KEY (`kategoriya_id`) REFERENCES `kategoriya_ekzamena` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_gruppa_prepodavatel`
    FOREIGN KEY (`prepodavatel_id`) REFERENCES `prepodavatel` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `zachislenie` (
  `plan_id`         INT NOT NULL,
  `gruppa_id`       INT NOT NULL,
  `kurator_id`      INT NOT NULL,
  `chasov_teorii`   SMALLINT NOT NULL DEFAULT 0,
  `chasov_praktiki` SMALLINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`plan_id`, `gruppa_id`),
  INDEX `fk_zachislenie_gruppa_idx`  (`gruppa_id` ASC)  VISIBLE,
  INDEX `fk_zachislenie_kurator_idx` (`kurator_id` ASC) VISIBLE,
  CONSTRAINT `fk_zachislenie_plan`
    FOREIGN KEY (`plan_id`) REFERENCES `plan_podgotovki` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_zachislenie_gruppa`
    FOREIGN KEY (`gruppa_id`) REFERENCES `gruppa_podgotovki` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_zachislenie_kurator`
    FOREIGN KEY (`kurator_id`) REFERENCES `prepodavatel` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `kontrolnyy_test` (
  `id`             INT NOT NULL AUTO_INCREMENT,
  `plan_id`        INT NOT NULL,
  `ekzamenator_id` INT NOT NULL,
  `tip_testa`      ENUM('diagnosticheskiy','promezhutochnyy','itogovyy','probnyy') NOT NULL,
  `nomer_popytki`  TINYINT NOT NULL DEFAULT 1,
  `data_testa`     DATETIME NOT NULL,
  `kolvo_oshibok`  TINYINT NULL,
  `otsenka`        TINYINT NULL COMMENT 'Оценка (цель - 5)',
  `sdan_na_otlichno` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `test_popytka_UNIQUE` (`plan_id` ASC, `tip_testa` ASC, `nomer_popytki` ASC) VISIBLE,
  INDEX `fk_test_ekzamenator_idx` (`ekzamenator_id` ASC) VISIBLE,
  CONSTRAINT `fk_test_plan`
    FOREIGN KEY (`plan_id`) REFERENCES `plan_podgotovki` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_test_ekzamenator`
    FOREIGN KEY (`ekzamenator_id`) REFERENCES `prepodavatel` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

-- ---------------------------------------------------------------
-- Оплата и сертификат об отличной подготовке
-- ---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `platezh` (
  `id`            INT NOT NULL AUTO_INCREMENT,
  `plan_id`       INT NOT NULL,
  `sposob_id`     INT NOT NULL,
  `summa`         DECIMAL(10,2) NOT NULL,
  `data_platezha` DATETIME NOT NULL,
  `naznachenie`   ENUM('kurs','materialy','povtornyy_test') NOT NULL DEFAULT 'kurs',
  PRIMARY KEY (`id`),
  INDEX `fk_platezh_plan_idx`   (`plan_id` ASC)   VISIBLE,
  INDEX `fk_platezh_sposob_idx` (`sposob_id` ASC) VISIBLE,
  CONSTRAINT `fk_platezh_plan`
    FOREIGN KEY (`plan_id`) REFERENCES `plan_podgotovki` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_platezh_sposob`
    FOREIGN KEY (`sposob_id`) REFERENCES `sposob_oplaty` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sertifikat_otlichiya` (
  `id`               INT NOT NULL AUTO_INCREMENT,
  `plan_id`          INT NOT NULL,
  `nomer`            VARCHAR(20) NOT NULL,
  `data_vydachi`     DATE NOT NULL,
  `data_okonchaniya` DATE NOT NULL,
  `podrazdelenie`    VARCHAR(150) NULL,
  `itogovaya_otsenka` TINYINT NOT NULL DEFAULT 5 COMMENT 'Всегда 5 при выдаче',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `sertifikat_nomer_UNIQUE`     (`nomer` ASC)     VISIBLE,
  UNIQUE INDEX `sertifikat_plan_UNIQUE`      (`plan_id` ASC)    VISIBLE,
  CONSTRAINT `fk_sertifikat_plan`
    FOREIGN KEY (`plan_id`) REFERENCES `plan_podgotovki` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
