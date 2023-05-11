module Web.Controller.ParagraphCtas where

import Web.Controller.Prelude
import Web.View.ParagraphCtas.Index
import Web.View.ParagraphCtas.New
import Web.View.ParagraphCtas.Edit
import Web.View.ParagraphCtas.Show

instance Controller ParagraphCtasController where
    action ParagraphCtaAction = do
        paragraphCtas <- query @ParagraphCta |> fetch
        render IndexView { .. }

    action NewParagraphCtaAction { landingPageId } = do
        let paragraphCta = newRecord |> set #landingPageId landingPageId
        render NewView { .. }

    action ShowParagraphCtaAction { paragraphCtaId } = do
        paragraphCta <- fetch paragraphCtaId
        render ShowView { .. }

    action EditParagraphCtaAction { paragraphCtaId } = do
        paragraphCta <- fetch paragraphCtaId
        render EditView { .. }

    action UpdateParagraphCtaAction { paragraphCtaId } = do
        paragraphCta <- fetch paragraphCtaId
        paragraphCta
            |> buildParagraphCta
            |> ifValid \case
                Left paragraphCta -> render EditView { .. }
                Right paragraphCta -> do
                    paragraphCta <- paragraphCta |> updateRecord
                    setSuccessMessage "ParagraphCta updated"
                    redirectTo EditParagraphCtaAction { .. }

    action CreateParagraphCtaAction = do
        let paragraphCta = newRecord @ParagraphCta
        paragraphCta
            |> buildParagraphCta
            |> ifValid \case
                Left paragraphCta -> render NewView { .. }
                Right paragraphCta -> do
                    paragraphCta <- paragraphCta |> createRecord
                    setSuccessMessage "ParagraphCta created"
                    redirectTo ParagraphCtaAction

    action DeleteParagraphCtaAction { paragraphCtaId } = do
        paragraphCta <- fetch paragraphCtaId
        deleteRecord paragraphCta
        setSuccessMessage "ParagraphCta deleted"
        redirectTo ParagraphCtaAction

buildParagraphCta paragraphCta = paragraphCta
    |> fill @'["title", "landingPageId", "weight"]
