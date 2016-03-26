<?php
/******************************************************************************
 * Wikipedia Account Creation Assistance tool                                 *
 *                                                                            *
 * All code in this file is released into the public domain by the ACC        *
 * Development Team. Please see team.json for a list of contributors.         *
 ******************************************************************************/

namespace Waca\Providers\Interfaces;

/**
 * IP Location provider interface
 */
interface ILocationProvider
{
	/**
	 * @param string $address IP address
	 *
	 * @return array
	 */
	public function getIpLocation($address);
}
