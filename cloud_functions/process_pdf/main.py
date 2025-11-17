import os
import json
import fitz   # PyMuPDF
from appwrite.client import Client
from appwrite.services.storage import Storage
from appwrite.services.databases import Databases


def main(context):
    req = context.req
    res = context.res

    try:
        # -------------------------------------------------------------
        # 1. Parse event data (file upload trigger)
        # -------------------------------------------------------------
        event_data = json.loads(os.environ.get("APPWRITE_FUNCTION_EVENT_DATA", "{}"))

        bucket_id = event_data.get("bucketId")
        file_id = event_data.get("$id")

        if not bucket_id or not file_id:
            return res.json({"error": "Missing bucketId or fileId from event"}, status_code=400)

        # -------------------------------------------------------------
        # 2. Initialize Appwrite client
        # -------------------------------------------------------------
        client = (
            Client()
            .set_endpoint(os.environ["APPWRITE_FUNCTION_ENDPOINT"])
            .set_project(os.environ["APPWRITE_FUNCTION_PROJECT_ID"])
            .set_key(os.environ["APPWRITE_API_KEY"])
        )

        storage = Storage(client)
        databases = Databases(client)

        # -------------------------------------------------------------
        # 3. Download the PDF file
        # -------------------------------------------------------------
        pdf_bytes = storage.get_file_download(bucket_id, file_id)

        temp_path = f"/tmp/{file_id}.pdf"
        with open(temp_path, "wb") as f:
            f.write(pdf_bytes)

        # -------------------------------------------------------------
        # 4. Extract text using PyMuPDF
        # -------------------------------------------------------------
        doc = fitz.open(temp_path)
        pages_text = []

        for page in doc:
            text = page.get_text("text")
            pages_text.append(text)

        full_text = "\n".join(pages_text)

        # -------------------------------------------------------------
        # 5. Split text into paragraphs
        # -------------------------------------------------------------
        paragraphs = [p.strip() for p in full_text.split("\n\n") if p.strip()]

        # -------------------------------------------------------------
        # 6. Create a book document in Appwrite
        # -------------------------------------------------------------
        database_id = os.environ["SCRIBE_DATABASE_ID"]
        books_collection = os.environ["SCRIBE_BOOKS_COLLECTION_ID"]
        paragraphs_collection = os.environ["SCRIBE_PARAGRAPHS_COLLECTION_ID"]

        book_doc = databases.create_document(
            database_id,
            books_collection,
            document_id="unique()",
            data={
                "fileId": file_id,
                "bucketId": bucket_id,
                "title": "Untitled Book",
                "author": "Unknown",
                "pageCount": doc.page_count,
                "paragraphCount": len(paragraphs),
                "processed": True
            }
        )

        book_id = book_doc["$id"]

        # -------------------------------------------------------------
        # 7. Store paragraphs in Appwrite DB
        # -------------------------------------------------------------
        for index, para in enumerate(paragraphs):
            databases.create_document(
                database_id,
                paragraphs_collection,
                document_id="unique()",
                data={
                    "bookId": book_id,
                    "index": index,
                    "text": para
                }
            )

        # -------------------------------------------------------------
        # 8. Return success response
        # -------------------------------------------------------------
        return res.json({
            "success": True,
            "message": "PDF processed successfully",
            "bookId": book_id,
            "pageCount": doc.page_count,
            "paragraphCount": len(paragraphs)
        })

    except Exception as e:
        return res.json({"success": False, "error": str(e)}, status_code=500)
