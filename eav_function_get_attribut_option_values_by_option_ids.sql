DROP FUNCTION IF EXISTS getValuesByOptionIds;

DELIMITER $$
CREATE FUNCTION `getValuesByOptionIds`
(
   optionIds VARCHAR(255)
   )
   RETURNS VARCHAR(255)
   DETERMINISTIC
BEGIN
  DECLARE iter INTEGER DEFAULT 0;
  DECLARE result VARCHAR(255) DEFAULT '';
  DECLARE previousIter VARCHAR(255) DEFAULT '';

  iters: WHILE LENGTH(SUBSTRING_INDEX(optionIds, ',', iter + 1)) != LENGTH(previousIter) DO
  SET iter = iter + 1;
  SET previousIter = SUBSTRING_INDEX(optionIds, ',', iter);

  IF iter = 1 THEN
    SET result = (select tmp.value from eav_attribute_option_value tmp where tmp.option_id = SUBSTRING_INDEX(optionIds, ',', iter));
  ELSEIF iter > 1 THEN
    SET result = concat(result, ',', (select tmp.value from eav_attribute_option_value tmp where tmp.option_id = SUBSTRING_INDEX(SUBSTRING_INDEX(optionIds, ',', iter), ',', -1)));
  END IF;
  END WHILE iters;

  RETURN result;
END$$
DELIMITER ;
