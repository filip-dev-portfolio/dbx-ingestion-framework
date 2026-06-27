import fnmatch
import logging
import os

import paramiko


logger = logging.getLogger(__name__)


class SFTPClient:
    """
    Wrapper around Paramiko for SFTP file ingestion.

    """

    def __init__(
        self,
        host: str,
        port: int,
        username: str,
        password: str,
    ):
        self.host = host
        self.port = port
        self.username = username
        self.password = password

        self.transport = None
        self.sftp = None

    ###########################################################################
    # Connection
    ###########################################################################

    def connect(self):
        """
        Establish SFTP connection.
        """
        logger.info(f"Connecting to {self.host}:{self.port}")

        self.transport = paramiko.Transport((self.host, self.port))
        self.transport.connect(
            username=self.username,
            password=self.password
        )

        self.sftp = paramiko.SFTPClient.from_transport(
            self.transport
        )

        logger.info("Connection established.")

    def disconnect(self):
        """
        Close SFTP connection.
        """
        logger.info("Closing SFTP connection.")

        if self.sftp:
            self.sftp.close()

        if self.transport:
            self.transport.close()

        logger.info("Connection closed.")

    ###########################################################################
    # Listing
    ###########################################################################

    def list_files(
        self,
        remote_path: str,
        filename_pattern: str,
    ) -> list[str]:
        """
        List files matching a filename pattern.

        Parameters
        ----------
        remote_path
            Remote SFTP directory.

        filename_pattern
            Wildcard pattern (*.csv, report_*.txt, etc.)

        Returns
        -------
        list[str]
        """

        files = self.sftp.listdir(remote_path)

        matched_files = [
            f
            for f in files
            if fnmatch.fnmatch(f, filename_pattern)
        ]

        logger.info(
            f"Found {len(matched_files)} file(s) matching "
            f"{filename_pattern}"
        )

        return matched_files

    ###########################################################################
    # Retrieval
    ###########################################################################

    def retrieve_file(
        self,
        remote_file: str,
        local_file: str,
    ):
        """
        Download a single file.
        """

        logger.info(
            f"Downloading {remote_file} -> {local_file}"
        )

        self.sftp.get(
            remote_file,
            local_file
        )

    def retrieve_multiple_files(
        self,
        remote_path: str,
        filename_pattern: str,
        local_path: str,
    ) -> list[str]:
        """
        Download all matching files.

        Returns
        -------
        list[str]
            Downloaded filenames.
        """

        downloaded_files = []

        files = self.list_files(
            remote_path,
            filename_pattern
        )

        for filename in files:

            remote_file = f"{remote_path.rstrip('/')}/{filename}"
            local_file = os.path.join(
                local_path,
                filename
            )

            self.retrieve_file(
                remote_file,
                local_file
            )

            downloaded_files.append(filename)

        logger.info(
            f"Downloaded {len(downloaded_files)} file(s)."
        )

        return downloaded_files

    ###########################################################################
    # Archive
    ###########################################################################

    def move_file(
        self,
        source_file: str,
        destination_file: str,
    ):
        """
        Move a file on the SFTP server.
        """

        logger.info(
            f"Moving {source_file} -> {destination_file}"
        )

        self.sftp.rename(
            source_file,
            destination_file
        )

    def archive_files(
        self,
        remote_path: str,
        archive_path: str,
        filenames: list[str],
    ):
        """
        Archive previously downloaded files.

        Parameters
        ----------
        remote_path
            Source directory on the SFTP server.

        archive_path
            Destination archive directory.

        filenames
            List of downloaded filenames.
        """

        for filename in filenames:

            source = f"{remote_path.rstrip('/')}/{filename}"
            destination = f"{archive_path.rstrip('/')}/{filename}"

            self.move_file(
                source_file=source,
                destination_file=destination
            )

        logger.info(
            f"Archived {len(filenames)} file(s)."
        )
    ###########################################################################
    # Delete
    ###########################################################################

    def delete_file(
        self,
        remote_file: str,
    ):
        """
        Delete a file from the SFTP server.
        """

        logger.info(f"Deleting {remote_file}")

        self.sftp.remove(remote_file)
        
    def delete_files(
        self,
        remote_path: str,
        filenames: list[str],
    ):
        """
        Delete previously downloaded files.
        """

        for filename in filenames:

            remote_file = f"{remote_path.rstrip('/')}/{filename}"

            self.delete_file(remote_file)

        logger.info(
            f"Deleted {len(filenames)} file(s)."
        )