<?php
namespace Waca\Pages;

use PDO;
use Request;
use Waca\PageBase;
use Waca\SecurityConfiguration;

class PageMain extends PageBase
{
	/**
	 * Main function for this page, when no actions are called.
	 */
	protected function main()
	{
		$config = $this->getSiteConfiguration();

		$database = gGetDb();

		$requestSectionData = array();

		if ($config->getEmailConfirmationEnabled()) {
			$query = "SELECT * FROM request WHERE status = :type AND emailconfirm = 'Confirmed' LIMIT :lim;";
			$totalQuery = "SELECT COUNT(id) FROM request WHERE status = :type AND emailconfirm = 'Confirmed';";
		}
		else {
			$query = "SELECT * FROM request WHERE status = :type LIMIT :lim;";
			$totalQuery = "SELECT COUNT(id) FROM request WHERE status = :type;";
		}

		$statement = $database->prepare($query);
		$statement->bindValue(':lim', $config->getMiserModeLimit(), PDO::PARAM_INT);

		$totalRequestsStatement = $database->prepare($totalQuery);

		foreach ($config->getRequestStates() as $type => $v) {
			$statement->bindValue(":type", $type);
			$statement->execute();

			$requests = $statement->fetchAll(PDO::FETCH_CLASS, 'Request');

			/** @var Request $req */
			foreach ($requests as $req) {
				$req->setDatabase($database);
			}

			$totalRequestsStatement->bindValue(':type', $type);
			$totalRequestsStatement->execute();
			$totalRequests = $totalRequestsStatement->fetchColumn();
			$totalRequestsStatement->closeCursor();

			$requestSectionData[$v['header']] = array(
				'requests' => $requests,
				'total'    => $totalRequests,
				'api'      => $v['api'],
			);
		}

		$this->assign('requestLimitShowOnly', $config->getMiserModeLimit());

		$query = <<<SQL
		SELECT request.id, request.name, request.checksum
		FROM request /* PageMain::main() */
		JOIN log ON log.objectid = request.id AND log.objecttype = 'Request'
		WHERE log.action LIKE 'Closed%'
		ORDER BY log.timestamp DESC
		LIMIT 5;
SQL;

		$statement = $database->prepare($query);
		$statement->execute();

		$last5result = $statement->fetchAll(PDO::FETCH_ASSOC);

		$this->assign('lastFive', $last5result);
		$this->assign('requestSectionData', $requestSectionData);

		$this->setTemplate('mainpage/mainpage.tpl');
	}

	/**
	 * Sets up the security for this page. If certain actions have different permissions, this should be reflected in
	 * the return value from this function.
	 *
	 * If this page even supports actions, you will need to check the route
	 *
	 * @return SecurityConfiguration
	 * @category Security-Critical
	 */
	protected function getSecurityConfiguration()
	{
		return SecurityConfiguration::internalPage();
	}
}